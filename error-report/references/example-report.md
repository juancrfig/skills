# Error Report — API returns 500 on checkout

Date: 2026-04-20
Status: CLOSED
Last referenced: 2026-04-21

## Bug Description

Checkout endpoint `/api/v2/checkout` returns HTTP 500 for ~30% of requests. Expected: 200 with order confirmation. No errors in application logs; only Nginx logs show 500.

Exact error from Nginx access log:
```
POST /api/v2/checkout HTTP/1.1" 500 37 "-" "Mozilla/5.0 ..."
```

## Initial Hypotheses

- Race condition in inventory lock
- Database connection pool exhausted
- Recent deploy introduced bad migration
- Nginx misconfiguration after cert renewal

## Investigation Log

- Branch 1: Race condition in inventory lock → added distributed locking → still 500s → abandoned
- Branch 2: DB connection pool exhausted → checked `pg_stat_activity`, only 12/100 connections used → abandoned
- Branch 3: Bad migration → rolled back last 3 migrations, issue persisted → abandoned
- Branch 4: Nginx misconfiguration → compared cert renewal timestamp with error spike; Nginx reloaded but upstream timeout was lowered to 2s during automation → pursued

## Root Cause

Nginx `proxy_read_timeout` was accidentally set to 2 seconds during an automated certificate renewal script that regenerated the site config from a stale template. Requests taking longer than 2s (checkout with payment verification) were cut off, producing Nginx-level 500s with no application log entry.

## Solution

Restored `proxy_read_timeout` to 60s in `/etc/nginx/sites-available/api`. Added a config validation step (`nginx -t`) to the cert renewal script before reload. Deployed fix at 14:30 UTC; 500 rate dropped to zero within 5 minutes.

## Lessons

The root cause was not anticipated because the error looked like an application failure (500 from an API endpoint) yet left no application logs. The cert renewal had completed successfully, so infrastructure was not initially suspected. The misleading signal was the absence of application logs, which pointed toward Nginx rather than the app. In future, any 500 without application logs should trigger an immediate infrastructure-config check before deep application debugging.

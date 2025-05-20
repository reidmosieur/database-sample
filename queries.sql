-- campaigns(id, name, owner_id)
-- emails(id, campaign_id, recipient, opened_at, bounced)
-- users(id, name)

-- open rate / campagign, sorted by open rate
SELECT
  c.id AS campaign_id,
  c.name AS campaign_name,
  COUNT(e.id) AS total_emails,
  COUNT(e.opened_at) AS opened_emails,
  ROUND(COUNT(e.opened_at) * 100.0 / NULLIF(COUNT(e.id), 0), 2) AS open_rate_percentage
FROM
  campaigns c
JOIN
  emails e ON c.id = e.campaign_id
WHERE
  e.bounced = FALSE
GROUP BY
  c.id, c.name
ORDER BY
  open_rate_percentage DESC;

-- top 5 users
SELECT 
    u.id AS user_id,
    u.name,
    COUNT(e.id) AS sent_emails
FROM 
    users u
JOIN 
    campaigns c ON c.owner_id = u.id
JOIN 
    emails e ON e.campaign_id = c.id
GROUP BY 
    u.id, u.name
ORDER BY 
    sent_emails DESC
LIMIT 5;

-- bounce rate / user
SELECT 
    u.id AS user_id,
    u.name,
    COUNT(*) AS total_emails,
    SUM(CASE WHEN e.bounced THEN 1 ELSE 0 END) AS bounced_emails,
    ROUND(SUM(CASE WHEN e.bounced THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS bounce_rate_percentage
FROM 
    users u
JOIN 
    campaigns c ON c.owner_id = u.id
JOIN 
    emails e ON e.campaign_id = c.id
GROUP BY 
    u.id, u.name
ORDER BY 
    bounce_rate_percentage DESC;

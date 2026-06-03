SELECT 
      d.drug_name,
      COUNT(ae.event_id) AS total_adverse_events,
      SUM(
          CASE 
              WHEN serious_event = 1
              THEN 1
              ELSE 0
              END
)AS serious_adverse_events,
SUM(
          CASE 
              WHEN hospitalized = 1
              THEN 1
              ELSE 0
              END
)AS hospitalizations,
SUM(
          CASE 
              WHEN death = 1
              THEN 1
              ELSE 0
              END
)AS deaths
FROM adverse_events ae
INNER JOIN drugs d 
ON ae.drug_id = d.drug_id
GROUP BY d.drug_name
ORDER BY total_adverse_events DESC;
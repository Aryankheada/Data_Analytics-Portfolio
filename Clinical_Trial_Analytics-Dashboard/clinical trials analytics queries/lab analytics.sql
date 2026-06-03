WITH lab_analytics AS(
        SELECT 
              lr.test_name,
              ae.event_severity,
              COUNT(DISTINCT ae.patient_id)  AS total_patients,
               COUNT(DISTINCT ae.event_id) AS total_AE,
                ROUND(AVG(lr.improvement_score),2) AS avg_improvement_score,
               CASE
                   WHEN lr.improvement_score < 0
				   THEN 'Worsened'
                      WHEN lr.improvement_score BETWEEN 0 AND 20
                      THEN 'Stable'
                      ELSE 'Improved'
END AS lab_status
FROM lab_results lr
LEFT JOIN adverse_events ae
ON lr.patient_id = ae.patient_id
WHERE ae.event_severity IS NOT NULL
GROUP BY  lr.test_name,
              ae.event_severity,
              CASE
                  WHEN lr.improvement_score < 0
                  THEN 'Worsened'
                  WHEN lr.improvement_score BETWEEN 0 AND 20
                      THEN 'Stable'
                      ELSE 'Improved'
                      END
 )                 
SELECT *
FROM lab_analytics

ORDER BY total_AE,
          avg_improvement_score ASC;
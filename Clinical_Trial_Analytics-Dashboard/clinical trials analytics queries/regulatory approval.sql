WITH regulatory_approval AS (
                 SELECT 
                      ct.phase,
                      ct.trial_name,
                      MAX(rr.delay_days) AS delay_days,
					COUNT(DISTINCT pte.patient_id)  AS total_patients,
                    COUNT(DISTINCT ae.event_id) AS total_AE,
                    COUNT(DISTINCT
                     CASE 
                     WHEN pte.completion_status = 'Completed'
					 THEN pte.patient_id
                      END
  ) AS completed_patients,
                        COUNT(DISTINCT
                         CASE 
                         WHEN pte.enrollment_status = 'Dropped'
                        THEN pte.patient_id
                        END
) AS dropout_patients
FROM clinical_trials ct
INNER JOIN patient_trial_enrollment pte
ON ct.trial_id = pte.trial_id
INNER JOIN regulatory_reports rr
ON ct.trial_id = rr.trial_id
LEFT JOIN adverse_events ae
ON pte.patient_id = ae.patient_id
AND pte.trial_id = ae.trial_id
GROUP BY  ct.phase,
                      ct.trial_name
),
trial_metrics AS (
SELECT *,
       ROUND(CAST(completed_patients AS DECIMAL(10,2))
        / 
        total_patients * 100,2) AS completion_rate,
        ROUND(CAST(dropout_patients AS DECIMAL(10,2))
        / 
        total_patients * 100,2) AS dropout_rate,
        ROUND(CAST(total_AE AS DECIMAL(10,2))
        / 
        total_patients * 100,2) AS AE_rate
FROM regulatory_approval
)
SELECT *,
        CASE 
            WHEN completion_rate > 70
            AND AE_rate < 15
            AND delay_days < 30
            THEN 'Ready for Approval'
            
            WHEN completion_rate BETWEEN 50 AND 70
            THEN 'Needs Monitoring'
            ELSE 'High risk'
            END AS approval_flag
FROM trial_metrics
ORDER BY CASE
             WHEN approval_flag = 'Ready for Approval' THEN 1
              WHEN approval_flag = 'Needs Monitoring' THEN 2
              ELSE 3
END,
completion_rate DESC,
AE_rate ASC
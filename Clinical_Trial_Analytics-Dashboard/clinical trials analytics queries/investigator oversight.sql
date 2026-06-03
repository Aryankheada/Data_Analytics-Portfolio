WITH investigator_oversight AS(
              SELECT 
                    inv.investigator_name,
                    inv.specialization,
                    ts.hospital_name,
                    ts.site_name,
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
FROM investigators inv
INNER JOIN trial_sites ts
ON inv.site_id = ts.site_id 
INNER JOIN clinical_trials ct
ON ts.trial_id = ct.trial_id
INNER JOIN patient_trial_enrollment pte
ON ct.trial_id = pte.trial_id
LEFT JOIN adverse_events ae
ON pte.patient_id = ae.patient_id
AND pte.trial_id = ae.trial_id
GROUP BY  inv.investigator_name,
                    inv.specialization,
                    ts.hospital_name,
                    ts.site_name
),
investigator_metrics AS(
      SELECT *,
        ROUND(CAST(completed_patients AS DECIMAL(10,2))
        / 
        total_patients * 100,2) AS completion_rate,
        ROUND(CAST(total_AE AS DECIMAL(10,2))
        / total_patients *100,2) AS AE_rate,
        ROUND(CAST(dropout_patients  AS DECIMAL(10,2))
        /total_patients *100,2) AS dropout_rate
FROM investigator_oversight
)
SELECT *,
         CASE
             WHEN completion_rate > 60
                  AND AE_rate < 15
                  THEN 'Strong Oversight'
			WHEN completion_rate BETWEEN 45 AND 60
                  THEN 'Moderate Oversight'
ELSE 'Need Review'
END AS oversight_flag
FROM investigator_metrics
ORDER BY 
         CASE
              WHEN oversight_flag = 'Strong Oversight' THEN 1
               WHEN oversight_flag = 'Moderate Oversight' THEN 2
               ELSE 3
END,
completion_rate DESC,
AE_rate ASC
        
              
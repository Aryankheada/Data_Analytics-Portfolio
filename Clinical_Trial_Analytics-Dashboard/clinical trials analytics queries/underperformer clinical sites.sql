WITH underperfm_clinical_site AS(
                SELECT 
                     ts.site_name,
                     ts.hospital_name,
                     COUNT(DISTINCT pte.patient_id)  AS total_patients,
                     	COUNT(DISTINCT ae.event_id) AS total_AE,
                              SUM(
                     CASE 
                     WHEN pte.completion_status = 'Completed'
					 THEN 1
                     ELSE 0
                      END
  ) AS completed_patients,
                        SUM(
                         CASE 
                         WHEN pte.enrollment_status = 'Dropped'
                        THEN 1
                        ELSE 0
                        END
) AS dropout_patients
FROM patient_trial_enrollment pte
INNER JOIN trial_sites ts
ON pte.site_id = ts.site_id
LEFT JOIN adverse_events ae
ON pte.patient_id = ae.patient_id
AND pte.trial_id = ae.trial_id
GROUP BY ts.site_name,
		ts.hospital_name        
),
site_metrics AS (
SELECT *,
              (total_AE/total_patients *100) AS AE_rate,
       ROUND(CAST(completed_patients AS DECIMAL(10,2))
        / 
        total_patients * 100,2) AS completion_rate
FROM underperfm_clinical_site
)
SELECT *,
           CASE
                WHEN completion_rate < 50 AND AE_rate > 20 
                THEN 'High risk'
                WHEN completion_rate BETWEEN 50 AND 65
                THEN 'Medium'
                ELSE 'Low Risk'
                END AS risk_flag
FROM site_metrics
ORDER BY 
        CASE 
			WHEN risk_flag = 'High Risk' THEN 1
            WHEN risk_flag = 'Medium' THEN 2
            ELSE 3 
END,
AE_rate DESC,
completion_rate ASC

            
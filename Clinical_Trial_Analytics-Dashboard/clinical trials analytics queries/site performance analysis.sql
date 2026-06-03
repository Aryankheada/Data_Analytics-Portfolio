WITH site_analysis AS (
          SELECT 
                 ts.site_name,
				 ts.hospital_name,
				COUNT(DISTINCT patient_id) AS total_patients_enrolled,
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
                        END
) AS dropout_patients
FROM patient_trial_enrollment pte
INNER JOIN trial_sites ts 
ON pte.site_id = ts.site_id
GROUP BY ts.site_name,
     ts.hospital_name
)
SELECT *,
        ROUND(CAST(completed_patients AS DECIMAL(10,2))
        / total_patients_enrolled * 100,2) AS completion_rate
FROM site_analysis
ORDER BY completion_rate DESC
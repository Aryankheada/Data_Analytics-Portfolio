WITH drug_safety_eff AS (
                     SELECT 
                            d.drug_name,
                            COUNT(DISTINCT ct.trial_id) AS total_trials,
							COUNT(DISTINCT ae.event_id) AS total_AE,
                            COUNT(DISTINCT pte.patient_id) AS total_enrolled_patients,
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
FROM drugs d
INNER JOIN clinical_trials ct
ON d.drug_id = ct.drug_id
INNER JOIN patient_trial_enrollment pte
ON ct.trial_id = pte.trial_id
LEFT JOIN adverse_events ae
ON pte.patient_id = ae.patient_id
AND pte.trial_id = ae.trial_id
GROUP BY d.drug_name
)
SELECT*,
      (total_AE/total_enrolled_patients *100) AS AE_rate,
       ROUND(CAST(completed_patients AS DECIMAL(10,2))
        / 
        total_enrolled_patients * 100,2) AS completion_rate
FROM drug_safety_eff
ORDER BY completion_rate DESC,
          AE_rate ASC

                            
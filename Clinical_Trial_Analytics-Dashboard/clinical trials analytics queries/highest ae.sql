WITH highest_ae AS (
           SELECT
                 ct.indication,
                 COUNT(DISTINCT ct.trial_id) AS total_trials,
							COUNT(DISTINCT ae.event_id) AS total_AE,
                            COUNT(DISTINCT pte.patient_id) AS total_enrolled_patients
FROM clinical_trials ct
INNER JOIN patient_trial_enrollment pte
ON ct.trial_id = pte.trial_id
LEFT JOIN adverse_events ae
ON pte.patient_id = ae.patient_id
AND pte.trial_id = ae.trial_id
GROUP BY ct.indication 
)
SELECT *,
          (total_AE/total_enrolled_patients *100) AS AE_rate
FROM 
highest_ae
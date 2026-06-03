SELECT 
      ct.phase,
      COUNT(DISTINCT ct.trial_id) AS total_trials,
      ROUND(AVG(ct.actual_enrollment),2) AS avg_enrollment,
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
FROM clinical_trials ct
INNER JOIN patient_trial_enrollment pte
ON ct.trial_id = pte.trial_id
GROUP BY ct.phase
ORDER BY ct.phase
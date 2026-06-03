WITH dropout_pttrn_analysis AS (
                   SELECT 
                   ct.phase,
                   pte.dropout_reason,
                   COUNT(DISTINCT pte.patient_id) AS total_enrolled_patients,
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
WHERE pte.dropout_reason <> 'NA'
GROUP BY  ct.phase,
		  pte.dropout_reason   
)
SELECT *,
      ROUND((dropout_patients/total_enrolled_patients) *100.0,2) AS dropout_rate
FROM dropout_pttrn_analysis
ORDER BY dropout_rate DESC
      
      
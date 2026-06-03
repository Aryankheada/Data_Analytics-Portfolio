
 SELECT 
    *
FROM
    (SELECT 
        COUNT(*) AS total_patients
    FROM
        patients) p
        CROSS JOIN
    (SELECT 
        COUNT(*) AS total_trials
    FROM
        clinical_trials) ct
        CROSS JOIN
    (SELECT 
        COUNT(*) AS total_drugs
    FROM
        drugs) d
        CROSS JOIN
    (SELECT 
        COUNT(*) AS total_adverse_events
    FROM
        adverse_events) ae
        CROSS JOIN
    (SELECT 
        COUNT(*) AS serious_adverse_events
    FROM
        adverse_events
    WHERE
        serious_event = 1) sae
        CROSS JOIN
    (SELECT 
        ROUND(AVG(age), 2) AS avg_patient_age
    FROM
        patients) apa
        CROSS JOIN
    (SELECT 
        COUNT(*) AS completed_enrollment
    FROM
        patient_trial_enrollment
    WHERE
        completion_status = 'Completed') ce;
          
          

-- THE MURDERER:

WITH gym_checkins AS (

    SELECT person_id, name

    FROM get_fit_now_member

    JOIN get_fit_now_check_in ON get_fit_now_member.id = get_fit_now_check_in.membership_id

    WHERE membership_status = 'gold'

      AND id LIKE '48Z%'

      AND check_in_date = '20180109'

), suspects AS (

    SELECT gym_checkins.person_id, gym_checkins.name, plate_number, gender

    FROM gym_checkins

    JOIN person ON gym_checkins.person_id = person.id

    JOIN drivers_license ON person.license_id = drivers_license.id

)

SELECT name FROM suspects

WHERE INSTR(plate_number, 'H42W') > 0 AND gender = 'male';



-- THE GUY BEHIND THE SCENES:




WITH event_goers AS (

    SELECT person_id, COUNT(1) AS n_checkins

    FROM facebook_event_checkin

    WHERE event_name = 'SQL Symphony Concert'

      AND `date` LIKE '201712%'

    GROUP BY person_id

    HAVING n_checkins = 3

),

matching_suspects AS (

    SELECT id AS license_id

    FROM drivers_license

    WHERE gender = 'female' AND hair_color = 'red'

      AND car_make = 'Tesla' AND car_model = 'Model S'

      AND height >= 64 AND height <= 68

), 

suspects AS (

    SELECT person.id AS person_id, name, annual_income

    FROM matching_suspects AS ms

    JOIN person ON ms.license_id = person.license_id

    JOIN income ON person.ssn = income.ssn

)

SELECT name

FROM suspects

JOIN event_goers ON suspects.person_id = event_goers.person_id;




-- name:

-- Miranda Priestly



SELECT * FROM get_fit_now_member WHERE person_id=(SELECT person_id FROM interview WHERE person_id=(SELECT id FROM person
WHERE ((SELECT description FROM crime_scene_report
	WHERE date=20180115 AND city='SQL City' AND type='murder') 
	LIKE '%'||address_street_name||'%' AND name LIKE '%Annabel Miller%')
UNION ALL
SELECT id FROM person
WHERE (address_street_name='Northwestern Dr') AND address_number='4919'))
-- 1A. WHAT is THE OVERALL default RATE?--
SELECT 
	count(*) as total_loans,
	sum(defaulted) as total_defaults,
	round(sum(defaulted)/count(*)*100,2) as default_percent
FROM study_da.loan_applications

-- 1B. HOW DOES IT BREAK DOWN BY CREDIT SCORE RANGE (eg 520-599, 600-649, 650-699, 700-749, 750+)
select 
	case
		when bp.credit_score between 520 and 599 then '520-599'
		when bp.credit_score between 600 and 649 then '600-649'
		when bp.credit_score between 650 and 699 then '650-699'
		when bp.credit_score between 700 and 749 then '700-749'
		when bp.credit_score >= 750 then '750+'
		else 'Below 520'
	end as credit_score_bucket,
	count(*) as total_loans,
	sum(defaulted) as total_defaults,
	round(sum(defaulted)/count(*)*100,2) as default_percent
from study_da.loan_applications	la
join study_da.borrower_profiles bp 	
on la.borrower_id = bp.borrower_id
group by credit_score_bucket
order by credit_score_bucket;

-- 2A. IS THERE A RELATIONSHIP BETWEEN A BORROWER'S DEBT-TO-INCONME (DTI) RATIO AND THE LIKEHOOD OF DEFAULTING?
select 
	case
		when la.dti_ratio < 20 then '0-19'
		when la.dti_ratio between 20 and 29 then '20-29'
		when la.dti_ratio between 30 and 39 then '30-39'
		when la.dti_ratio between 40 and 49 then '40-49'
		else '50+'
	end as dti_ratio_bucket,
	count(*) as total_loans,
	sum(defaulted) as total_defaults,
	round(sum(defaulted)/count(*)*100,2) as default_percent
from study_da.loan_applications	la
group by dti_ratio_bucket
order by dti_ratio_bucket;

-- 3A. WHICH LOAN PURPOSES HAVE THE HIGHEST DEFAULT RATE?
select 
	la.loan_purpose, 
	count(*) as total_loans,
	sum(defaulted) as total_defaults,
	round(sum(defaulted)/count(*)*100,2) as default_percent
from loan_applications la 
group by la.loan_purpose
order by default_percent desc;

-- 3B. DOES THE AVERAGE LOAN AMOUNT DIFER SIGNIFICANTLY BETWEEN DEFAULTED AND NON-DEFAULTED LOANS?
select 
	defaulted, 
	count(*) as total_loans,
	round(avg(la.loan_amount),0) as avg_loan_amount,
	min(la.loan_amount),
	max(la.loan_amount)
from loan_applications la 
group by defaulted;

-- 4A. HOW DOES EMPLOYMENT STATUS AFFECT DEFAULT RIKS?
select 
	bp.employment_status,
	count(*) as total_loans,
	sum(defaulted) as total_defaults,
	round(sum(defaulted)/count(*)*100,2) as default_percent
from study_da.loan_applications	la
join study_da.borrower_profiles bp 	
on la.borrower_id = bp.borrower_id
group by bp.employment_status
order by default_percent desc;

-- 4B. HOW DO YEARS EMPLOYED AFFECT DEFAULT RISK?
select 
	case 
		when bp.years_employed < 2 then '<2 years'
		when bp.years_employed between 2 and 5 then '2-5 years'
		when bp.years_employed between 6 and 10 then '6-10 years'
	else '10+ years'
	end as employment_tenure,
count(*) as total_loans,
	sum(defaulted) as total_defaults,
	round(sum(defaulted)/count(*)*100,2) as default_percent
from study_da.loan_applications	la
join study_da.borrower_profiles bp 	
on la.borrower_id = bp.borrower_id
group by employment_tenure
order by 
	case employment_tenure
		when '<2 years' then 1
		when '2-5 years' then 2
		when '6-10 years' then 3
		when '10+ years' then 4
		else 5
		end asc;
-- 4C. ARE BORROWERS WITH LESS THAN 2 YEARS OF EMPLOYMENT MORE LIKELY TO DEFAULT?
select 
	case 
		when bp.years_employed < 2 then '< 2 years'
		else '2+ years'
	end as employment_group,
count(*) as total_loans,
	sum(defaulted) as total_defaults,
	round(sum(defaulted)/count(*)*100,2) as default_percent
from study_da.loan_applications	la
join study_da.borrower_profiles bp 	
on la.borrower_id = bp.borrower_id
group by employment_group
order by employment_group;	
	

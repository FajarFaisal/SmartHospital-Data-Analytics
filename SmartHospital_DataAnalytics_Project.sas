/*Summer2026 BUSI4590U - Special Tps in Tech.Mngt - Data Analytics
Project: SmartHospital Analytics 
Fajar Faisal
Tuesday, August 5, 2026 @11:59pm*/

/*1) IMPORT AND ORGANIZE THE DATA*/

libname mydata '~/Group2 Project'; /*create the permanent library*/
/*import excel workbook files*/
proc import datafile= '~/Group2 Project/SmartHospital_Departments.xlsx'/*import department file*/
out=mydata.departments
dbms=xlsx
replace;
getnames= yes;
run;

proc import datafile= '~/Group2 Project/SmartHospital_Lab_Results.xlsx' /*import lab_results file*/
out=mydata.lab_results
dbms=xlsx
replace;
getnames= yes;
run;

proc import datafile= '~/Group2 Project/SmartHospital_Patient_Visits.xlsx' /*import patient visits file*/
out=mydata.patient_visits
dbms=xlsx
replace;
getnames= yes;
run;

proc import datafile= '~/Group2 Project/SmartHospital_Physicians.xlsx' /*import physicians file*/
out=mydata.physicians
dbms=xlsx
replace;
getnames= yes;
run;

/*inspect structures with PROC CONTENTS*/
proc contents data=mydata.departments; /*inspect departments*/
title "STRUCTURE INSPECTION FOR DEPARTMENTS:";
run;

proc contents data=mydata.lab_results; /*inspect lab results*/
title "STRUCTURE INSPECTION FOR LAB RESULTS:";
run;

proc contents data=mydata.patient_visits; /*inspect patient visits*/
title "STRUCTURE INSPECTION FOR PATIENT VISITS:";
run;

proc contents data=mydata.physicians; /*inspect physicians*/
title "STRUCTURE INSPECTION FOR PHYSICIANS:";
run;

/*confirm date and datetime fields*/
data hospital_prepared; 
set mydata.patient_visits; 

Arrival_Date=datepart(Arrival_DateTime);
Arrival_Time=timepart(Arrival_DateTime);
Arrival_Hour=hour(Arrival_DateTime);

format Arrival_Date date9.;
format Arrival_Time time8.;
run;

/*2) CREATE ANALYTICAL VARIABLES*/
data mydata.patient_visits_prepared; 
set mydata.patient_visits;

Arrival_Time=timepart(Arrival_DateTime);
Arrival_Hour=hour(Arrival_DateTime);


/*SAS variables, conditional logic, and date/time functions to create useful fields*/
Weekday=weekday(Arrival_Date); /*create Weekday var*/

if Weekday in (1,7) then Weekend_Flag=1; /*create Weekend_Flag var*/
else Weekend_Flag=0;  

if Age < 18 then Age_Group="child"; /*create age groups var*/
else if Age < 65 then Age_Group="adult";
else Age_Group="senior";

Arrival_Hour = hour(Arrival_DateTime); /*create arrival hour var*/

if Age < 18 then Age_Group="child"; /*create age groups var*/
else if Age < 65 then Age_Group="adult";
else Age_Group="senior";

if Triage_Level <=2 then High_Priority_Flag=1; /*create high priority flag var*/
else High_Priority_Flag=0;

if Wait_Time_Minutes >45 then Long_Wait_Flag=1; /*create long wait flag var*/
else Long_Wait_Flag=0;

format Arrival_Time time8.;

run;

/*3) INTEGRATE THE TABLES*/
proc sql; 
create table mydata.hospital_analysis as 
select 
/*pacient visit data*/
v.Arrival_Hour,
v.Weekday,
v.Weekend_Flag,
v.Age_Group,
v.High_Priority_Flag,
v.Long_Wait_Flag,
v.Visit_ID, 
v.Patient_ID, 
v.Age, 
v.Gender, 
v.Arrival_Date,
v.Arrival_DateTime,
v.Arrival_Mode,
v.Triage_Level,
v.Wait_Time_Minutes,
v.Treatment_Time_Minutes,
v.Total_Length_of_Stay_Minutes,
v.Disposition,
v.Insurance_Type,
v.Shift,

/*lab result data*/
l.Lab_Record_ID,
l.Blood_Test_Time_Minutes,
l.Imaging_Required,
l.Imaging_Time_Minutes,
l.Lab_Delay_Minutes,
l.Number_of_Tests,
l.Result_Status,

/*physican data*/
p.Physician_ID,
p.Specialty,
p.Years_of_Experience,
p.Performance_Rating,
p.Average_Patients_Per_Day,

/*department data*/
d.Department_ID,
d.Daily_Capacity,
d.Department_Name,
d.Number_of_Beds,
d.Service_Category

from mydata.patient_visits_prepared as v

left join mydata.lab_results as l
	on v.Visit_ID = l.Visit_ID
        
left join mydata.physicians as p
	on v.Physician_ID = p.Physician_ID
        
left join mydata.departments as d
	on v.Department_ID = d.Department_ID;
quit;

proc contents data=mydata.hospital_analysis; /*check if new vars are into hospital analysis dataset*/
title "HOSPITAL ANALYSIS VARIABLES";
run;

/*4) DESCRIBE HOSPITAL OPERATIONS*/

proc print data=mydata.hospital_analysis(obs=12); /*print first 12 observations*/
title "HOSPITAL ANALYSIS DATASET - FIRST 12 OBSERVATIONS:";
run; 

proc freq data=mydata.hospital_analysis; /*summerize patient volume*/
tables Department_ID;
title "DEPARTMENT PATIENT VOLUME SUMMARY:";

proc means data=mydata.hospital_analysis mean median min max std;/*summarize length of stay*/
	var Total_Length_of_Stay_Minutes;
title "PATIENT LENGTH OF STAY SUMMARY:";
run; 
	
proc means data=mydata.hospital_analysis mean median min max std;/*summerize wait-time*/
	var Age 
	Wait_Time_Minutes
	Treatment_Time_Minutes
	Total_Length_of_Stay_Minutes
	Lab_Delay_Minutes
	Number_of_Tests; 
	title "HOSPITAL WAIT TIME SUMMARY:";
run; 

proc freq data=mydata.hospital_analysis; /*summerize triage, disposition, department*/
	tables Department_ID
	Disposition
	Triage_Level
	Arrival_Mode; 
	title "HOSPITAL'S TRIAGE, DISPOSITION, DEPARTMENT SUMMARY:";
run; 

proc tabulate data=mydata.hospital_analysis; /*summerize average shift wait time*/
	class Shift; 
		var Wait_Time_Minutes; 
	table Shift, Wait_Time_Minutes*mean; 
	title "AVERAGE WAIT TIME PER SHIFTS SUMMARY:"; 
run; 

proc means data=mydata.hospital_analysis mean median min max std; /*summarize laboratory activity*/
	var Blood_Test_Time_Minutes
	Lab_Delay_Minutes
	Imaging_Time_Minutes
	Number_of_Tests;
	title "LABORATORY ACTIVITY SUMMARY:";
run; 

/*5) CREATE GRAPHICAL ANALYSIS*/	

proc sgplot data=mydata.hospital_analysis; /*histogram chart: wait times*/
histogram Wait_Time_Minutes;
title "PATIENT VISIT WAIT TIMES - HISTOGRAM CHART:";
xaxis label="wait time (mins)"; 
yaxis label="patient visits";
run; 

proc sgplot data=mydata.hospital_analysis; /*boxplot chart: department wait times*/
vbox Wait_Time_Minutes / category=Department_ID;
title "DEPARTMENT WAIT TIME DISTRIBUTION - BOX PLOT CHART:";
xaxis label="department"; 
yaxis label="wait time (mins)";
run; 

proc sgplot data=mydata.hospital_analysis; /*bar chart: avg deparemtn lab activities*/
vbar Department_ID / response=Number_of_Tests stat=mean;
title "AVERAGE LAB TESTS PER DEPARTMENT - BAR CHART:";
xaxis label="department"; 
yaxis label="averge lab tests";
run;
 
proc corr data=mydata.hospital_analysis plots=scatter; /*scatter-plot chart: wait time & length of stay*/
    var Wait_Time_Minutes;
    with Total_Length_of_Stay_Minutes;
    title "WAIT TIME VS LENGTH OF STAY - SCATTER PLOT:";
run;

proc reg data=mydata.hospital_analysis;/*reggression chart: wait time & length of stay*/
model Total_Length_of_Stay_Minutes = Wait_Time_Minutes;
title "LENGTH OF STAY & WAIT TIME - LINEAR REGGRESION:";
run;
quit;

proc sgplot data=mydata.hospital_analysis; /*bar chart: dipution pacient outcomes*/
vbar Disposition;
title "PATIENT VISITS BY DISPOSITION OUTCOME - BAR CHART:";
xaxis label="disposition"; 
yaxis label="patient visits";
run; 

/*6) CONDUCT T-TESTS*/

/*perform a one-sample t-test comparing average wait time with a management benchmark of 45 minutes*/
proc ttest data=mydata.hospital_analysis h0=45; 
	var Wait_Time_Minutes; 
	title "AVERAGE WAIT TIME VS 45-MINUTE BENCHMARK- ONE SAMPLE TTEST:";
run; 

/*perform an independent two-sample t-test comparing wait time for weekday and weekend visits*/
proc ttest data=mydata.hospital_analysis;
	class Weekend_Flag; 
	var Wait_Time_Minutes; 
	title "COMPARING WAIT TIME FOR WEEKDAY AND WEEKEND VISITS - INDEPENDENT TWO SAMPLE TTEST:";
run; 

/* 7) CONDUCT ONE-WAY ANOVA AND POST HOC ANALYSIS */

/* 
Null hypothesis:
	H₀: μEmergency Medicine = μCardiology = μOrthopedics = μNeurology = μGeneral Medicine = μPediatrics = μRespiratory Medicine = μGastroenterology
	All departments have the same mean wait time.
Alternative hypothesis:
	Hₐ: at least one mean differs
	Not all departments have the same mean wait time. */
	
/* perform a one-way anova to test whether mean wait time differs across departments */
proc anova data=mydata.hospital_analysis;
	class Department_Name;
	model Wait_Time_Minutes=Department_Name;
	title "One-Way ANOVA: Patient Wait Time by Departments (Minutes)";
run;

/* since the overall test is significant (p-value less than 0.05), reject null hypothesis, use post hoc test such as tukey */
proc anova data=mydata.hospital_analysis;
	class Department_Name;
	model Wait_Time_Minutes=Department_Name;
	means Department_Name / tukey cldiff;
	title "Tukey Post Hoc Test: Department Differences in Wait Time (Minutes)";
run;

/* 8) ANALYZE CORRELATION AND SIMPLE REGRESSION */

/* calculate Pearsons correlations */
proc corr data=mydata.hospital_analysis Pearson plots=scatter;
    var Wait_Time_Minutes 
        Treatment_Time_Minutes
        Total_Length_of_Stay_Minutes
        Number_of_Tests;
    title "Pearson Correlation Analysis of Patient Flow Metrics";
run;

/* build a simple linear regression model explaining total length of stay minutes using wait time minutes */
proc reg data=mydata.hospital_analysis;
	model Total_Length_of_Stay_Minutes=Wait_Time_Minutes;
	title "Simple Linear Regression Model: Total Length of Stay Using Wait Time (Minutes)";
run;
quit;

/* 9) TWO-WAY ANOVA */

/* perform a two-way anova */
proc glm data=mydata.hospital_analysis;
    class Department_ID Shift;
    model Wait_Time_Minutes =
          Department_ID
          Shift
          Department_ID*Shift;
    title "Two-Way ANOVA: Department, Shift, and Interaction Effects on Wait Time";
run;
quit;

/* post hoc tukey test */
proc glm data=mydata.hospital_analysis;
    class Department_ID Shift;
    model Wait_Time_Minutes =
          Department_ID
          Shift
          Department_ID*Shift;
    lsmeans Shift / adjust=tukey pdiff cl;

    title "Tukey Post Hoc Test: Pairwise Shift Comparisons for Wait Time";
run;
quit;


/*assumption check */
proc glm data=mydata.hospital_analysis;
    class Department_ID Shift;
    model Wait_Time_Minutes =
          Department_ID
          Shift
          Department_ID*Shift;
    output out=anova_diag
           predicted=Predicted_Minutes
           residual=Residual;
run;
quit;

proc sgplot data=anova_diag;
    scatter x=Predicted_Minutes y=Residual;
    refline 0 / axis=y lineattrs=(pattern=shortdash color=red);
    title "Residuals vs Predicted Wait Time";
    xaxis label="Predicted Wait Time";
    yaxis label="Residual";
run;

ods select TestsForNormality Histogram;
proc univariate data=anova_diag normal;
    var Residual;
    histogram Residual / normal;
    title "Normality Assessment of Residuals";
run;
ods select all;

/* 10) BUILD A MULTIPLE REGRESSION MODEL */

proc reg data=mydata.hospital_analysis;
    model Total_Length_of_Stay_Minutes =
        Wait_Time_Minutes
        Treatment_Time_Minutes
        Lab_Delay_Minutes
        Number_of_Tests
        Age
        Triage_Level
        Years_of_Experience
        Performance_Rating / vif clb;
    title "Multiple Regression Model: Predicting Total Length of Stay";
run;
quit;

/*consider categorical predictors */
proc glm data=mydata.hospital_analysis;
    class Department_ID Shift;
    model Total_Length_of_Stay_Minutes =
        Wait_Time_Minutes
        Treatment_Time_Minutes
        Lab_Delay_Minutes
        Number_of_Tests
        Age
        Triage_Level
        Years_of_Experience
        Performance_Rating
        Department_ID
        Shift;
    title "Regression with Numeric and Categorical Predictors";
run;
quit;

















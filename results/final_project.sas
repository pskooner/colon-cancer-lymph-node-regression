NOTE: Copyright (c) 2016 by SAS Institute Inc., Cary, NC, USA.
NOTE: SAS (r) Proprietary Software 9.4 (TS1M7)
      Licensed to UNIVERSITY OF TEXAS SYSTEM - SFA T&R, Site 70080470.
NOTE: This session is executing on the X64_DSRV19  platform.



NOTE: Analytical products:

      SAS/STAT 15.2
      SAS/ETS 15.2
      SAS/OR 15.2
      SAS/IML 15.2
      SAS/QC 15.2

NOTE: Additional host information:

 X64_DSRV19 WIN 10.0.20348  Server

NOTE: SAS initialization used:
      real time           1.62 seconds
      cpu time            1.15 seconds

1    /*=============================================================================
2      PH 1820 - Applied Linear Regression - Final Project
3      Author:    Parminder Kooner
4      Date:       Spring 2026
5      Dataset:    colon (Stage B/C colon cancer adjuvant chemo trial, N=888)
6
7      Research Question:
8      Do markers of advanced local disease (obstruction, perforation, adherence,
9      extent of local spread) predict greater lymph node involvement at diagnosis
10     in Stage B/C colon cancer patients, after adjusting for age, sex, tumor
11     differentiation, treatment, and time from surgery to registration?
12
13     Response (Y): nodes (number of positive lymph nodes count, treated as
14                          quasi-continuous; log-transform if skewed)
15     Primary predictors:    obstruct, perfor, adhere, extent
16     Adjustment covariates: age, sex, rx, differ, surg
17     Excluded: time/status/etype (censored), node4 (collinear w/ response),
18               id, study, rownames
19   =============================================================================*/
20
21
22   /*=============================================================================*/
23   /* Step 1. Data Import and Preparation */
24   /*=============================================================================*/
25
26
27   /* Import Data Set */
28   proc import datafile="C:\Users\pkooner\Desktop\Kooner\colon_full.csv"
29       out=colon
30       dbms=csv
31       replace;
32       guessingrows=max;
33   run;

34    /**********************************************************************
35    *   PRODUCT:   SAS
36    *   VERSION:   9.4
37    *   CREATOR:   External File Interface
38    *   DATE:      27APR26
39    *   DESC:      Generated SAS Datastep Code
40    *   TEMPLATE SOURCE:  (None Specified.)
41    ***********************************************************************/
42       data WORK.COLON    ;
43       %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
44       infile 'C:\Users\pkooner\Desktop\Kooner\colon_full.csv' delimiter = ',' MISSOVER DSD
44 ! lrecl=32767 firstobs=2 ;
45          informat id best32. ;
46          informat study best32. ;
47          informat rx $9. ;
48          informat sex best32. ;
49          informat age best32. ;
50          informat obstruct best32. ;
51          informat perfor best32. ;
52          informat adhere best32. ;
53          informat nodes $2. ;
54          informat status best32. ;
55          informat differ $2. ;
56          informat extent best32. ;
57          informat surg best32. ;
58          informat node4 best32. ;
59          informat time best32. ;
60          informat etype best32. ;
61          format id best12. ;
62          format study best12. ;
63          format rx $9. ;
64          format sex best12. ;
65          format age best12. ;
66          format obstruct best12. ;
67          format perfor best12. ;
68          format adhere best12. ;
69          format nodes $2. ;
70          format status best12. ;
71          format differ $2. ;
72          format extent best12. ;
73          format surg best12. ;
74          format node4 best12. ;
75          format time best12. ;
76          format etype best12. ;
77       input
78                   id
79                   study
80                   rx  $
81                   sex
82                   age
83                   obstruct
84                   perfor
85                   adhere
86                   nodes  $
87                   status
88                   differ  $
89                   extent
90                   surg
91                   node4
92                   time
93                   etype
94       ;
95       if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
96       run;

NOTE: The infile 'C:\Users\pkooner\Desktop\Kooner\colon_full.csv' is:
      Filename=C:\Users\pkooner\Desktop\Kooner\colon_full.csv,
      RECFM=V,LRECL=32767,File Size (bytes)=81687,
      Last Modified=27Apr2026:17:45:37,
      Create Time=27Apr2026:17:45:37

NOTE: 1858 records were read from the infile 'C:\Users\pkooner\Desktop\Kooner\colon_full.csv'.
      The minimum record length was 38.
      The maximum record length was 46.
NOTE: The data set WORK.COLON has 1858 observations and 16 variables.
NOTE: DATA statement used (Total process time):
      real time           0.07 seconds
      cpu time            0.04 seconds


1858 rows created in WORK.COLON from C:\Users\pkooner\Desktop\Kooner\colon_full.csv.



NOTE: WORK.COLON data set was successfully created.
NOTE: The data set WORK.COLON has 1858 observations and 16 variables.
NOTE: PROCEDURE IMPORT used (Total process time):
      real time           0.55 seconds
      cpu time            0.51 seconds


97
98   /* Fixing Data Types */
99   DATA colon;
100      SET colon;
101      /* Convert nodes to numeric */
102      nodes_num = INPUT(nodes, BEST12.);
103
104      /* Convert differ safely (handle "NA") */
105      IF differ = "NA" THEN differ_num = .;
106      ELSE differ_num = INPUT(differ, BEST12.);
107
108      /* Replace originals */
109      DROP nodes differ;
110      RENAME nodes_num = nodes
111             differ_num = differ;
112  RUN;

NOTE: Invalid argument to function INPUT at line 102 column 17.
id=94 study=1 rx=Lev+5FU sex=0 age=26 obstruct=0 perfor=0 adhere=1 nodes=NA status=0 differ=2 extent=4
surg=1 node4=1 time=2869 etype=2 nodes_num=. differ_num=2 _ERROR_=1 _N_=187
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=94 study=1 rx=Lev+5FU sex=0 age=26 obstruct=0 perfor=0 adhere=1 nodes=NA status=0 differ=2 extent=4
surg=1 node4=1 time=2869 etype=1 nodes_num=. differ_num=2 _ERROR_=1 _N_=188
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=99 study=1 rx=Lev sex=1 age=71 obstruct=0 perfor=0 adhere=1 nodes=NA status=1 differ=2 extent=4
surg=0 node4=1 time=569 etype=2 nodes_num=. differ_num=2 _ERROR_=1 _N_=197
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=99 study=1 rx=Lev sex=1 age=71 obstruct=0 perfor=0 adhere=1 nodes=NA status=1 differ=2 extent=4
surg=0 node4=1 time=219 etype=1 nodes_num=. differ_num=2 _ERROR_=1 _N_=198
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=143 study=1 rx=Lev+5FU sex=0 age=49 obstruct=0 perfor=0 adhere=0 nodes=NA status=0 differ=1
extent=3 surg=0 node4=0 time=2950 etype=2 nodes_num=. differ_num=1 _ERROR_=1 _N_=285
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=143 study=1 rx=Lev+5FU sex=0 age=49 obstruct=0 perfor=0 adhere=0 nodes=NA status=0 differ=1
extent=3 surg=0 node4=0 time=2950 etype=1 nodes_num=. differ_num=1 _ERROR_=1 _N_=286
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=189 study=1 rx=Lev sex=1 age=72 obstruct=0 perfor=0 adhere=0 nodes=NA status=0 differ=2 extent=3
surg=0 node4=1 time=2618 etype=2 nodes_num=. differ_num=2 _ERROR_=1 _N_=377
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=189 study=1 rx=Lev sex=1 age=72 obstruct=0 perfor=0 adhere=0 nodes=NA status=0 differ=2 extent=3
surg=0 node4=1 time=2618 etype=1 nodes_num=. differ_num=2 _ERROR_=1 _N_=378
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=199 study=1 rx=Lev+5FU sex=0 age=32 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=3
extent=3 surg=1 node4=1 time=490 etype=2 nodes_num=. differ_num=3 _ERROR_=1 _N_=397
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=199 study=1 rx=Lev+5FU sex=0 age=32 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=3
extent=3 surg=1 node4=1 time=183 etype=1 nodes_num=. differ_num=3 _ERROR_=1 _N_=398
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=338 study=1 rx=Lev sex=1 age=58 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=3 extent=3
surg=0 node4=1 time=885 etype=2 nodes_num=. differ_num=3 _ERROR_=1 _N_=675
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=338 study=1 rx=Lev sex=1 age=58 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=3 extent=3
surg=0 node4=1 time=174 etype=1 nodes_num=. differ_num=3 _ERROR_=1 _N_=676
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=358 study=1 rx=Lev+5FU sex=0 age=64 obstruct=1 perfor=0 adhere=0 nodes=NA status=0 differ=2
extent=3 surg=0 node4=1 time=2362 etype=2 nodes_num=. differ_num=2 _ERROR_=1 _N_=715
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=358 study=1 rx=Lev+5FU sex=0 age=64 obstruct=1 perfor=0 adhere=0 nodes=NA status=0 differ=2
extent=3 surg=0 node4=1 time=2362 etype=1 nodes_num=. differ_num=2 _ERROR_=1 _N_=716
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=365 study=1 rx=Lev+5FU sex=0 age=76 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=3
extent=3 surg=0 node4=1 time=186 etype=2 nodes_num=. differ_num=3 _ERROR_=1 _N_=729
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=365 study=1 rx=Lev+5FU sex=0 age=76 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=3
extent=3 surg=0 node4=1 time=186 etype=1 nodes_num=. differ_num=3 _ERROR_=1 _N_=730
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=383 study=1 rx=Lev sex=1 age=63 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=2 extent=3
surg=0 node4=1 time=1252 etype=2 nodes_num=. differ_num=2 _ERROR_=1 _N_=765
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=383 study=1 rx=Lev sex=1 age=63 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=2 extent=3
surg=0 node4=1 time=675 etype=1 nodes_num=. differ_num=2 _ERROR_=1 _N_=766
NOTE: Invalid argument to function INPUT at line 102 column 17.
id=502 study=1 rx=Lev+5FU sex=0 age=71 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=2
extent=3 surg=0 node4=1 time=1273 etype=2 nodes_num=. differ_num=2 _ERROR_=1 _N_=1003
NOTE: Invalid argument to function INPUT at line 102 column 17.
WARNING: Limit set by ERRORS= option reached.  Further errors of this type will not be printed.
id=502 study=1 rx=Lev+5FU sex=0 age=71 obstruct=0 perfor=0 adhere=0 nodes=NA status=1 differ=2
extent=3 surg=0 node4=1 time=700 etype=1 nodes_num=. differ_num=2 _ERROR_=1 _N_=1004
NOTE: Mathematical operations could not be performed at the following places. The results of the
      operations have been set to missing values.
      Each place is given by: (Number of times) at (Line):(Column).
      36 at 102:17
NOTE: There were 1858 observations read from the data set WORK.COLON.
NOTE: The data set WORK.COLON has 1858 observations and 16 variables.
NOTE: DATA statement used (Total process time):
      real time           0.07 seconds
      cpu time            0.06 seconds


113
114  /* Filter to one record per patient (etype=2 = death record).
115     Drop variables we're not using. Overwrites 'colon' with the analytic set.  */
116  DATA colon;
117      SET colon;
118      WHERE etype = 2;
119      DROP rownames id study time status etype node4;
120  RUN;

WARNING: The variable rownames in the DROP, KEEP, or RENAME list has never been referenced.
NOTE: There were 929 observations read from the data set WORK.COLON.
      WHERE etype=2;
NOTE: The data set WORK.COLON has 929 observations and 10 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.00 seconds


121
122  /* Data structure */
123  proc contents data=colon;
NOTE: Writing HTML Body file: sashtml.htm
124      title "Dataset Structure (Post-Cleaning)";
125  run;

NOTE: PROCEDURE CONTENTS used (Total process time):
      real time           0.39 seconds
      cpu time            0.21 seconds


126
127  /* Sanity check: should be N=929 after we kept 1 record for each patient */
128  PROC SQL;
129      SELECT COUNT(*) AS N FROM colon;
130  QUIT;
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.01 seconds
      cpu time            0.00 seconds


131
132  /* Check missingness on ALL analytic variables.
133     PROC MEANS handles numeric (continuous + numerically-coded categoricals); */
134
135  PROC MEANS DATA=colon NMISS N;
136      VAR nodes age sex obstruct perfor adhere differ extent surg;
137      TITLE "Missingness check: numeric variables";
138  RUN;

NOTE: There were 929 observations read from the data set WORK.COLON.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.02 seconds
      cpu time            0.01 seconds


139
140  /* PROC FREQ shows the distribution of categorical levels including missing. */
141
142  PROC FREQ DATA=colon;
143      TABLES rx sex obstruct perfor adhere differ extent surg / MISSING;
144      TITLE "Missingness check: categorical variables (incl. character rx)";
145  RUN;

NOTE: There were 929 observations read from the data set WORK.COLON.
NOTE: PROCEDURE FREQ used (Total process time):
      real time           0.02 seconds
      cpu time            0.01 seconds


146
147  /*  use complete-case analysis (drop the missing rows) */
148  DATA colon;
149      SET colon;
150      IF CMISS(OF nodes age sex rx obstruct perfor adhere differ extent surg) = 0;
151  RUN;

NOTE: There were 929 observations read from the data set WORK.COLON.
NOTE: The data set WORK.COLON has 888 observations and 10 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds


152
153   /* Check final N sample size after dropping the values */
154
155  PROC SQL;
156      SELECT COUNT(*) AS N_complete FROM colon;
157  QUIT;
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds


158
159  /*=============================================================================*/
160  /* Step 2. Exploratory Data Analysis */
161  /*=============================================================================*/
162
163  /* 2.1 Univariate summaries for continuous variables */
164  PROC MEANS DATA=colon N MEAN STD MIN Q1 MEDIAN Q3 MAX MAXDEC=2;
165      VAR nodes age;
166      TITLE "EDA: Continuous variable summaries";
167  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds


168
169  PROC UNIVARIATE DATA=colon;
170      VAR nodes age;
171      HISTOGRAM nodes age / NORMAL KERNEL;
172      QQPLOT nodes age / NORMAL(MU=EST SIGMA=EST);
173      TITLE "EDA: Distributions of continuous variables";
174  RUN;

NOTE: The normal kernel estimate for c=0.7852 has a bandwidth of 0.8079 and an AMISE of 0.0005.
NOTE: The normal kernel estimate for c=0.7852 has a bandwidth of 3.2316 and an AMISE of 0.0001.
NOTE: PROCEDURE UNIVARIATE used (Total process time):
      real time           1.79 seconds
      cpu time            0.76 seconds


175
176  /* 2.2 Frequency tables for categorical variables */
177  PROC FREQ DATA=colon;
178      TABLES rx sex obstruct perfor adhere differ extent surg;
179      TITLE "EDA: Categorical variable distributions";
180  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON.
NOTE: PROCEDURE FREQ used (Total process time):
      real time           0.02 seconds
      cpu time            0.03 seconds


181
182  /* 2.3 Bivariate: nodes vs. age */
183  PROC SGPLOT DATA=colon;
184      SCATTER X=age Y=nodes;
185      REG X=age Y=nodes;
186      TITLE "EDA: nodes vs age with regression line";
187  RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.22 seconds
      cpu time            0.04 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

188
189  /* 2.4 Boxplots: nodes by each categorical predictor */
190  PROC SGPLOT DATA=colon;  VBOX nodes / CATEGORY=rx;       TITLE "nodes by treatment (rx)";
190! RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.15 seconds
      cpu time            0.04 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

191  PROC SGPLOT DATA=colon;  VBOX nodes / CATEGORY=sex;      TITLE "nodes by sex";
191! RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.15 seconds
      cpu time            0.06 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

192  PROC SGPLOT DATA=colon;  VBOX nodes / CATEGORY=obstruct; TITLE "nodes by obstruct";
192! RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.17 seconds
      cpu time            0.06 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

193  PROC SGPLOT DATA=colon;  VBOX nodes / CATEGORY=perfor;   TITLE "nodes by perfor";
193! RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.20 seconds
      cpu time            0.04 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

194  PROC SGPLOT DATA=colon;  VBOX nodes / CATEGORY=adhere;   TITLE "nodes by adhere";
194! RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.11 seconds
      cpu time            0.04 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

195  PROC SGPLOT DATA=colon;  VBOX nodes / CATEGORY=differ;   TITLE "nodes by differ";
195! RUN;

NOTE: Since no format is assigned, the numeric category variable will use the default of BEST6.
NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.12 seconds
      cpu time            0.03 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

196  PROC SGPLOT DATA=colon;  VBOX nodes / CATEGORY=extent;   TITLE "nodes by extent";
196! RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.12 seconds
      cpu time            0.04 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

197  PROC SGPLOT DATA=colon;  VBOX nodes / CATEGORY=surg;     TITLE "nodes by surg";
197! RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.10 seconds
      cpu time            0.03 seconds

NOTE: There were 888 observations read from the data set WORK.COLON.

198
199  /* 2.5 Correlations between continuous variables */
200  PROC CORR DATA=colon PEARSON SPEARMAN;
201      VAR nodes age;
202      TITLE "EDA: Correlation between continuous variables";
203  RUN;

NOTE: PROCEDURE CORR used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds


204
205  /* 2.6 Cross-tabs to check for multicollinearity among local-disease markers */
206  PROC FREQ DATA=colon;
207      TABLES (obstruct perfor adhere)*extent / CHISQ;
208      TITLE "EDA: Local-disease marker associations";
209  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON.
NOTE: PROCEDURE FREQ used (Total process time):
      real time           0.03 seconds
      cpu time            0.03 seconds


210
211  /*=============================================================================*/
212  /* Step 3. Preliminary Full Main Effects Model ( Y = nodes, untransformed) */
213  /*=============================================================================*/
214
215  /* 3.1 Create indicator variables for categorical predictors.
216     Reference levels are chosen to be the clinically benign / "no" group:
217       rx       reference = Obs (observation)
218       sex      reference = 0  (female)
219       obstruct reference = 0  (no obstruction)
220       perfor   reference = 0  (no perforation)
221       adhere   reference = 0  (no adherence)
222       differ   reference = 1  (well-differentiated)
223       extent   reference = 1  (submucosa - least invasive)
224       surg     reference = 0  (short time from surgery)                        */
225
226  DATA colon_reg;
227      SET colon;
228      /* rx: 3-level character -> 2 indicators */
229      rx_lev   = (rx = "Lev");
230      rx_5fu   = (rx = "Lev+5FU");
231      /* differ: 3-level numeric -> 2 indicators */
232      differ_2 = (differ = 2);
233      differ_3 = (differ = 3);
234      /* extent: 4-level numeric -> 3 indicators */
235      extent_2 = (extent = 2);
236      extent_3 = (extent = 3);
237      extent_4 = (extent = 4);
238      /* sex, obstruct, perfor, adhere, surg are already 0/1 - use as-is */
239  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON.
NOTE: The data set WORK.COLON_REG has 888 observations and 17 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.03 seconds


240
241
242  /* 3.2 Fit the full main-effects model & residual diagnostics */
243  PROC REG DATA=colon_reg PLOTS=ALL;
244      MODEL nodes = age
245                    obstruct perfor adhere
246                    extent_2 extent_3 extent_4
247                    rx_lev rx_5fu
248                    sex
249                    differ_2 differ_3
250                    surg
251                    / CLB VIF;
252      OUTPUT OUT=full_diag P=yhat R=resid RSTUDENT=rstud
253             COOKD=cookd H=lev DFFITS=dffits;
254      TITLE "Step 3: Full main-effects model (Y = nodes)";
255  RUN;

255!      QUIT;

NOTE: The data set WORK.FULL_DIAG has 888 observations and 23 variables.
NOTE: PROCEDURE REG used (Total process time):
      real time           4.23 seconds
      cpu time            1.82 seconds


256
257  /*=============================================================================*/
258  /* Step 4. Model Diagnostics */
259  /*=============================================================================*/
260
261  /* 4.1 Residual plots - linearity & constant variance */
262  PROC SGPLOT DATA=full_diag;
263      SCATTER X=yhat Y=resid;
264      REFLINE 0 / AXIS=Y;
265      TITLE "Diagnostic: Residuals vs Fitted";
266  RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.11 seconds
      cpu time            0.04 seconds

NOTE: There were 888 observations read from the data set WORK.FULL_DIAG.

267
268  PROC SGPLOT DATA=full_diag;
269      SCATTER X=age Y=resid;
270      REFLINE 0 / AXIS=Y;
271      TITLE "Diagnostic: Residuals vs age";
272  RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.11 seconds
      cpu time            0.03 seconds

NOTE: There were 888 observations read from the data set WORK.FULL_DIAG.

273
274  /* 4.2 Normality of residuals */
275  PROC UNIVARIATE DATA=full_diag NORMAL;
276      VAR resid;
277      HISTOGRAM resid / NORMAL;
278      QQPLOT resid / NORMAL(MU=EST SIGMA=EST);
279      TITLE "Diagnostic: Normality of residuals";
280  RUN;

NOTE: PROCEDURE UNIVARIATE used (Total process time):
      real time           0.49 seconds
      cpu time            0.32 seconds


281
282  /* 4.3 Constant variance: Breusch-Pagan & White tests via PROC MODEL */
283  PROC MODEL DATA=colon_reg;
284      PARMS b0 b1-b13;
285
286      nodes =
287          b0
288          + b1*age
289          + b2*obstruct
290          + b3*perfor
291          + b4*adhere
292          + b5*extent_2
293          + b6*extent_3
294          + b7*extent_4
295          + b8*rx_lev
296          + b9*rx_5fu
297          + b10*sex
298          + b11*differ_2
299          + b12*differ_3
300          + b13*surg;
301

302      FIT nodes / WHITE BREUSCH=(age obstruct perfor adhere
303                                extent_2 extent_3 extent_4
304                                rx_lev rx_5fu sex
305                                differ_2 differ_3 surg);
306
307      TITLE "Breusch-Pagan & White Test (Full Model)";
308  RUN;


NOTE: At OLS Iteration 1 CONVERGE=0.001 Criteria Met.
308!      QUIT;

NOTE: PROCEDURE MODEL used (Total process time):
      real time           1.44 seconds
      cpu time            0.79 seconds


309
310  /* 4.4 Multicollinearity: VIFs (need numeric coding) */
311  DATA colon_num;
312      SET colon_reg;
313      /* Reference-coded indicator variables */
314      IF rx="Lev"     THEN rx_lev = 1; ELSE rx_lev = 0;
315      IF rx="Lev+5FU" THEN rx_5fu = 1; ELSE rx_5fu = 0;
316      differ_2 = (differ=2);
317      differ_3 = (differ=3);
318      extent_2 = (extent=2);
319      extent_3 = (extent=3);
320      extent_4 = (extent=4);
321  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON_REG.
NOTE: The data set WORK.COLON_NUM has 888 observations and 17 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds


322
323  PROC REG DATA=colon_num;
324      MODEL nodes = age sex obstruct perfor adhere surg
325                    rx_lev rx_5fu differ_2 differ_3 extent_2 extent_3 extent_4
326                    / VIF TOL COLLIN;
327      TITLE "Diagnostic: Multicollinearity (VIF / Tolerance)";
328  RUN;

328!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           1.59 seconds
      cpu time            0.64 seconds


329
330  /*=============================================================================*/
331  /* Step 5. Influential Points (Kutner Ch. 10) - Required by Rubric */
332  /*=============================================================================*/
333
334  PROC REG DATA=colon_num
335           PLOTS(LABEL ONLY)=(COOKSD RSTUDENTBYLEVERAGE DFFITS DFBETAS);
336      MODEL nodes = age sex obstruct perfor adhere surg
337                    rx_lev rx_5fu differ_2 differ_3 extent_2 extent_3 extent_4
338                    / INFLUENCE R;
339      OUTPUT OUT=infl_data
340             P=yhat R=resid RSTUDENT=rstud
341             COOKD=cookd H=lev DFFITS=dffits;
342      TITLE "Step 5: Influential points - Cook's D, DFFITS, DFBETAS";
343  RUN;

NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
NOTE: Data label collision avoidance has been disabled because the threshold has been reached. You
      can set LABELMAX=900 in the ODS GRAPHICS statement to restore collision avoidance.
343!      QUIT;

NOTE: The data set WORK.INFL_DATA has 888 observations and 23 variables.
NOTE: PROCEDURE REG used (Total process time):
      real time           2.86 seconds
      cpu time            1.25 seconds


344
345  /* Apply Kutner thresholds. With p=14 predictors + intercept and N=888:
346     - Leverage threshold:  2*p/n  = 2*15/888 ~ 0.03378378
347     - DFFITS threshold:    2*sqrt(p/n) = 2*sqrt(15/888) ~ 0.260
348     - DFBETAS threshold:   2/sqrt(n)   = 2/sqrt(888) ~ 0.067
349     - Studentized deleted residual: |t*| > Bonferroni critical                 */
350
351  %let n = 888;
352  %let p = 15;
353
354  DATA infl_flagged;
355      SET infl_data;
356      flag_lev    = (lev    > 2*&p/&n);
357      flag_dffits = (ABS(dffits) > 2*SQRT(&p/&n));
358      flag_cookd  = (cookd  > 4/&n);                   /* common rule-of-thumb */
359      flag_rstud  = (ABS(rstud) > 3);                    /* large outliers */
360      any_flag    = MAX(flag_lev, flag_dffits, flag_cookd, flag_rstud);
361  RUN;

NOTE: There were 888 observations read from the data set WORK.INFL_DATA.
NOTE: The data set WORK.INFL_FLAGGED has 888 observations and 28 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds


362
363  PROC PRINT DATA=infl_flagged (WHERE=(any_flag=1));
364      VAR nodes age sex obstruct perfor adhere extent differ rx surg
365          yhat resid rstud lev cookd dffits;
366      TITLE "Step 5: Flagged influential observations";
367  RUN;

NOTE: There were 99 observations read from the data set WORK.INFL_FLAGGED.
      WHERE any_flag=1;
NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.06 seconds
      cpu time            0.04 seconds


368
369  /* Sensitivity refit excluding flagged points */
370  PROC GLM DATA=infl_flagged (WHERE=(any_flag=0)) PLOTS=NONE;
371        CLASS rx sex obstruct perfor adhere differ extent surg;
372        MODEL nodes = age obstruct perfor adhere extent rx sex differ surg
373                      / SOLUTION CLPARM;
374        TITLE "Step 5: Sensitivity refit excluding flagged points";
375    RUN;

NOTE: The CLASS variable perfor has only one level: '0'.
375!        QUIT;

NOTE: PROCEDURE GLM used (Total process time):
      real time           0.03 seconds
      cpu time            0.03 seconds


376
377  /*=============================================================================*/
378  /* Step 6. Box-Cox to determine appropriate transformation */
379  /*=============================================================================*/
380
381  /* Box-Cox to determine appropriate transformation */
382  DATA colon_reg;
383      SET colon_reg;
384      nodes_bc = nodes + 1;
385  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON_REG.
NOTE: The data set WORK.COLON_REG has 888 observations and 18 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds


386
387  PROC TRANSREG DATA=colon_reg;
388      MODEL BOXCOX(nodes_bc) = IDENTITY(
389          age obstruct perfor adhere
390          extent_2 extent_3 extent_4
391          rx_lev rx_5fu sex
392          differ_2 differ_3 surg
393      );
394  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON_REG.
NOTE: PROCEDURE TRANSREG used (Total process time):
      real time           0.38 seconds
      cpu time            0.12 seconds


395
396
397  /* The BoxCox analysis identified a transformation with ?  -0.5 as the maximum likelihood
397! estimate.
398  However, the profile likelihood confidence interval for ? was relatively wide and included ? = 0,
399  indicating that the data do not provide strong evidence that ? = -0.5 is meaningfully better than
399!  ? = 0.
400  Given this, we did not adopt the ? = -0.5 transformation. Instead, we selected ? = 0,
400! corresponding to
401  a log(nodes + 1) transformation, because it represents a simpler and more interpretable
401! transformation
402  for our outcome. In this study, the number of positive lymph nodes has a clear clinical
402! interpretation,
403  and the log transformation preserves the direction of the relationship while allowing
404  effects to be interpreted on a relative scale. */
405
406  /*=============================================================================*/
407  /* Step 6. Response Transformation */
408  /*=============================================================================*/
409
410  /* Create log-transformed response */
411  /* A new dataset */
412  DATA colon_log;
413      SET colon_reg;
414      log_nodes = LOG(nodes + 1);
415  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON_REG.
NOTE: The data set WORK.COLON_LOG has 888 observations and 19 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds


416  /* Log transformation applied based on Box-Cox results and initial diagnostics
417     (right-skewness and variance heterogeneity) */
418
419  /* Fit model with transformed response */
420  PROC REG DATA=colon_log PLOTS=ALL;
421      MODEL log_nodes = age
422                        obstruct perfor adhere
423                        extent_2 extent_3 extent_4
424                        rx_lev rx_5fu
425                        sex
426                        differ_2 differ_3
427                        surg
428                        / CLB VIF;
429      OUTPUT OUT=log_diag P=yhat_log R=resid_log RSTUDENT=rstud_log
430             COOKD=cookd_log H=lev_log DFFITS=dffits_log;
431      TITLE "Step 6: Full model with log(nodes+1)";
432  RUN;

432!      QUIT;

NOTE: The data set WORK.LOG_DIAG has 888 observations and 25 variables.
NOTE: PROCEDURE REG used (Total process time):
      real time           3.52 seconds
      cpu time            1.78 seconds


433
434  /* Model Diagnostics after transformation */
435  /* Residuals vs fitted */
436  PROC SGPLOT DATA=log_diag;
437      SCATTER X=yhat_log Y=resid_log;
438      REFLINE 0 / AXIS=Y;
439      TITLE "Log Model: Residuals vs Fitted";
440  RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.12 seconds
      cpu time            0.03 seconds

NOTE: There were 888 observations read from the data set WORK.LOG_DIAG.

441
442  /* Normality */
443  PROC UNIVARIATE DATA=log_diag NORMAL;
444      VAR resid_log;
445      HISTOGRAM resid_log / NORMAL;
446      QQPLOT resid_log / NORMAL(MU=EST SIGMA=EST);
447      TITLE "Log Model: Residual Normality";
448  RUN;

NOTE: PROCEDURE UNIVARIATE used (Total process time):
      real time           0.48 seconds
      cpu time            0.26 seconds


449
450  /* Influence diagnostics for log-transformed model */
451  PROC REG DATA=colon_log;
452      MODEL log_nodes =
453          age obstruct perfor adhere
454          extent_2 extent_3 extent_4
455          rx_lev rx_5fu sex
456          differ_2 differ_3 surg
457          / INFLUENCE;
458
459      OUTPUT OUT=diag_log
460          RSTUDENT=rstud_log
461          H=leverage
462          COOKD=cookd_log
463          DFFITS=dffits_log;
464  RUN;

464!      QUIT;

NOTE: The data set WORK.DIAG_LOG has 888 observations and 23 variables.
NOTE: PROCEDURE REG used (Total process time):
      real time           1.48 seconds
      cpu time            0.90 seconds


465
466  /* Flagging influential observations */
467  DATA diag_log_flag;
468      SET diag_log;
469
470      flag_cookd  = (cookd  > 4/&n);
471      flag_dffits = (abs(dffits) > 2*sqrt(&p/&n));
472      flag_lev    = (leverage > 2*&p/&n);
473  RUN;

NOTE: Variable cookd is uninitialized.
NOTE: Variable dffits is uninitialized.
NOTE: Missing values were generated as a result of performing an operation on missing values.
      Each place is given by: (Number of times) at (Line):(Column).
      888 at 471:20
NOTE: There were 888 observations read from the data set WORK.DIAG_LOG.
NOTE: The data set WORK.DIAG_LOG_FLAG has 888 observations and 28 variables.
NOTE: DATA statement used (Total process time):
      real time           0.03 seconds
      cpu time            0.01 seconds


474
475  /* Constant variance tests for log-transformed model */
476  PROC MODEL DATA=colon_log;
477      PARMS b0 b1-b13;
478
479      log_nodes =
480          b0
481          + b1*age
482          + b2*obstruct
483          + b3*perfor
484          + b4*adhere
485          + b5*extent_2
486          + b6*extent_3
487          + b7*extent_4
488          + b8*rx_lev
489          + b9*rx_5fu
490          + b10*sex
491          + b11*differ_2
492          + b12*differ_3
493          + b13*surg;
494

495      FIT log_nodes / WHITE BREUSCH=(age obstruct perfor adhere
496                                    extent_2 extent_3 extent_4
497                                    rx_lev rx_5fu sex
498                                    differ_2 differ_3 surg);
499
500      TITLE "Breusch-Pagan & White Test (Log-Transformed Model)";
501  RUN;


NOTE: At OLS Iteration 1 CONVERGE=0.001 Criteria Met.
501!      QUIT;

NOTE: PROCEDURE MODEL used (Total process time):
      real time           1.25 seconds
      cpu time            0.75 seconds


502
503  /*=============================================================================*/
504  /* Step 7. Partial F Test */
505  /*=============================================================================*/
506
507  /* Reduced model (covariates only) */
508  PROC REG DATA=colon_log;
509      MODEL log_nodes = age sex differ_2 differ_3 rx_lev rx_5fu surg;
510      TITLE "Reduced Model for Partial F-test (No Disease Markers)";
511  RUN;

511!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           1.03 seconds
      cpu time            0.50 seconds


512
513  /* Full model */
514  PROC REG DATA=colon_log;
515      MODEL log_nodes = age sex differ_2 differ_3 rx_lev rx_5fu surg
516                        obstruct perfor adhere
517                        extent_2 extent_3 extent_4;
518      TITLE "Full Model for Partial F-test (With Disease Markers)";
519  RUN;

519!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           1.20 seconds
      cpu time            0.62 seconds


520
521  /*=============================================================================*/
522  /* Step 8. Interaction Terms */
523  /*=============================================================================*/
524
525  /* Create interactions */
526  DATA colon_interact;
527      SET colon_log;
528
529      int_obstruct_extent2 = obstruct * extent_2;
530      int_obstruct_extent3 = obstruct * extent_3;
531      int_obstruct_extent4 = obstruct * extent_4;
532
533      int_perfor_extent2 = perfor * extent_2;
534      int_perfor_extent3 = perfor * extent_3;
535      int_perfor_extent4 = perfor * extent_4;
536
537      int_adhere_extent2 = adhere * extent_2;
538      int_adhere_extent3 = adhere * extent_3;
539      int_adhere_extent4 = adhere * extent_4;
540  RUN;

NOTE: There were 888 observations read from the data set WORK.COLON_LOG.
NOTE: The data set WORK.COLON_INTERACT has 888 observations and 28 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.00 seconds


541
542
543  /* Fit interaction model */
544  PROC REG DATA=colon_interact;
545      MODEL log_nodes = age sex differ_2 differ_3 rx_lev rx_5fu surg
546                        obstruct perfor adhere
547                        extent_2 extent_3 extent_4
548                        int_obstruct_extent2 int_obstruct_extent3
549                        int_perfor_extent2   int_perfor_extent3
550                        int_adhere_extent2   int_adhere_extent3
551                        / VIF;
552      TITLE "Interaction Model (Fixed)";
553  RUN;

553!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           1.42 seconds
      cpu time            0.56 seconds


554
555  /*=============================================================================*/
556  /* Step 9. Model Selection (Best subsets and stepwise) */
557  /*=============================================================================*/
558
559  /* Best subsets */
560  PROC REG DATA=colon_log;
561      MODEL log_nodes = age sex differ_2 differ_3 rx_lev rx_5fu surg
562                        obstruct perfor adhere
563                        extent_2 extent_3 extent_4
564                        / SELECTION=ADJRSQ CP AIC BIC BEST=10;
565      TITLE "Model Selection - Best 10 Models";
566  RUN;

566!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           1.02 seconds
      cpu time            0.61 seconds


567
568  /* Stepwise */
569  PROC REG DATA=colon_log;
570      MODEL log_nodes = age sex differ_2 differ_3 rx_lev rx_5fu surg
571                        obstruct perfor adhere
572                        extent_2 extent_3 extent_4
573                        / SELECTION=STEPWISE SLENTRY=0.05 SLSTAY=0.05;
574      TITLE "Model Selection - Stepwise";
575  RUN;

575!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           0.75 seconds
      cpu time            0.42 seconds


576
577  /* Press Validation */
578  PROC REG DATA=colon_log;
579      MODEL log_nodes = age sex differ_2 differ_3 rx_lev rx_5fu surg
580                        obstruct perfor adhere
581                        extent_2 extent_3 extent_4
582                        / PRESS;
583      TITLE "PRESS Statistic for Validation";
584  RUN;

584!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           1.20 seconds
      cpu time            0.59 seconds


585
586  /*=============================================================================*/
587  /* STEP 10. After Selection - Final Model */
588  /*=============================================================================*/
589
590  PROC REG DATA=colon_log;
591      MODEL log_nodes = age differ_2 differ_3 extent_3
592                        / CLB VIF;
593      OUTPUT OUT=final_out P=yhat_final R=resid_final;
594      TITLE "Final Model";
595  RUN;

595!      QUIT;

NOTE: The data set WORK.FINAL_OUT has 888 observations and 21 variables.
NOTE: PROCEDURE REG used (Total process time):
      real time           0.86 seconds
      cpu time            0.43 seconds


596
597  /*
598  Final model excludes extent_4 despite its statistical significance in some models.
599
600  Reason:
601  - extent_4 represents the most advanced disease category and is highly correlated
602    with extent_3 (same underlying variable).
603  - Including both extent_3 and extent_4 did not meaningfully improve model fit
604    (minimal change in adjusted R-square, AIC/BIC, and PRESS).
605  - Stepwise selection did not retain extent_4.
606  - For parsimony and interpretability, extent_3 was retained as the primary
607    indicator of advanced disease.
608
609  Therefore, extent_4 was excluded from the final model.
610  */
611
612  /*=============================================================================*/
613  /* STEP 11. Lack-of-Fit Test */
614  /*=============================================================================*/
615
616  PROC REG DATA=colon_log;
617      MODEL log_nodes = age differ_2 differ_3 extent_3 / LACKFIT;
618      TITLE "Lack-of-Fit Test for Final Model";
619  RUN;

619!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           0.71 seconds
      cpu time            0.40 seconds


620
621
622  /*=============================================================================*/
623  /* STEP 12. Final Diagnostics */
624  /*=============================================================================*/
625
626  PROC SGPLOT DATA=final_out;
627      SCATTER X=yhat_final Y=resid_final;
628      REFLINE 0 / AXIS=Y;
629      TITLE "Final Model Residuals vs Fitted";
630  RUN;

NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.09 seconds
      cpu time            0.03 seconds

NOTE: There were 888 observations read from the data set WORK.FINAL_OUT.

631
632  PROC UNIVARIATE DATA=final_out NORMAL;
633      VAR resid_final;
634      HISTOGRAM resid_final / NORMAL;
635      QQPLOT resid_final / NORMAL(MU=EST SIGMA=EST);
636      TITLE "Final Model Normality";
637  RUN;

NOTE: PROCEDURE UNIVARIATE used (Total process time):
      real time           0.54 seconds
      cpu time            0.28 seconds


638
639  /*=============================================================================*/
640  /* STEP 13. Prediction and Intervals */
641  /*=============================================================================*/
642
643  PROC REG DATA=colon_log;
644      MODEL log_nodes = age differ_2 differ_3 extent_3
645                        / CLM CLI;
646      TITLE "Final Model: Confidence & Prediction Intervals";
647  RUN;

647!      QUIT;

NOTE: PROCEDURE REG used (Total process time):
      real time           0.76 seconds
      cpu time            0.57 seconds


648
649  /*=============================================================================*/
650  /* STEP 14. Bonferroni Simulatenous CI */
651  /*=============================================================================*/
652
653  PROC GLM DATA=colon_log;
654      CLASS extent differ;
655      MODEL log_nodes = age differ extent;
656      MEANS extent / BON;
657      TITLE "Bonferroni Simultaneous Confidence Intervals";
658  RUN;

NOTE: Means from the MEANS statement are not adjusted for other terms in the model.  For adjusted
      means, use the LSMEANS statement.
658!      QUIT;

NOTE: PROCEDURE GLM used (Total process time):
      real time           0.40 seconds
      cpu time            0.20 seconds



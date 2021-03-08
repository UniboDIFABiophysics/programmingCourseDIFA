```python
%matplotlib inline
```

# Random Numbers and MonteCarlo Methods


```python
import numpy as np
import pandas as pd
import seaborn as sns
import pylab as plt
import scipy.stats as st
import pdir as dir
```

## Random numbers and seeds


```python
import random

random.random()
```




    0.22321073814882275




```python
[random.random() for i in range(3)]
```




    [0.7364712141640124, 0.6766994874229113, 0.8921795677048454]




```python
[random.random() for i in range(3)]
```




    [0.08693883262941615, 0.4219218196852704, 0.029797219438070344]




```python
random.seed(42)
[random.random() for i in range(3)]
```




    [0.6394267984578837, 0.025010755222666936, 0.27502931836911926]




```python
random.seed(42)
[random.random() for i in range(3)]
```




    [0.6394267984578837, 0.025010755222666936, 0.27502931836911926]



### the linear congruential generator

a very simple way of generating random numbers: not a good one, but a good example

$$R_{n+1} = (a \cdot R_n + c) \text{mod} m$$

with appropriate constants a, c and m


```python
# values from the numerical recipies
m = 2**32
a = 1664525
c = 1013904223
```


```python
R0 = 4
R1 = (a*R0+c)%m
R1
```




    1020562323




```python
for i in range(5):
    print(R1/m)
    R1 = (a*R1+c)%m
```

    0.6126509555615485
    0.06787405931390822
    0.30464745592325926
    0.5426386359613389
    0.8115915204398334



```python
results = []
for i in range(5000):
    results.append(R1/m)
    R1 = (a*R1+c)%m
```


```python
plt.hist(results)
```




    (array([480., 466., 463., 520., 504., 513., 522., 516., 504., 512.]),
     array([2.93839024e-04, 1.00261839e-01, 2.00229839e-01, 3.00197840e-01,
            4.00165840e-01, 5.00133840e-01, 6.00101840e-01, 7.00069841e-01,
            8.00037841e-01, 9.00005841e-01, 9.99973841e-01]),
     <a list of 10 Patch objects>)




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_14_1.png)
    


## the random modules

between the standard libraries and the scientific stack, we have access to 3 set of random functions generation:

* random
* numpy.random
* scipy.stats


```python
import random as rn
dir(rn).public
```




    [0;35mproperty:[0m
        [1;34mBPF[0m[1;34m, [0m[1;34mLOG4[0m[1;34m, [0m[1;34mNV_MAGICCONST[0m[1;34m, [0m[1;34mRECIP_BPF[0m[1;34m, [0m[1;34mSG_MAGICCONST[0m[1;34m, [0m[1;34mTWOPI[0m
    [0;35mclass:[0m
        [1;34mRandom[0m[1;34m: [0m[1;30mRandom number generator base class used by bound module functions.[0m
        [1;34mSystemRandom[0m[1;34m: [0m[1;30mAlternate random number generator using sources provided[0m
    [0;35mfunction:[0m
        [1;34mbetavariate[0m[1;34m: [0m[1;30mBeta distribution.[0m
        [1;34mchoice[0m[1;34m: [0m[1;30mChoose a random element from a non-empty sequence.[0m
        [1;34mchoices[0m[1;34m: [0m[1;30mReturn a k sized list of population elements chosen with replacement.[0m
        [1;34mexpovariate[0m[1;34m: [0m[1;30mExponential distribution.[0m
        [1;34mgammavariate[0m[1;34m: [0m[1;30mGamma distribution.  Not the gamma function![0m
        [1;34mgauss[0m[1;34m: [0m[1;30mGaussian distribution.[0m
        [1;34mgetrandbits[0m[1;34m: [0m[1;30mgetrandbits(k) -> x.  Generates an int with k random bits.[0m
        [1;34mgetstate[0m[1;34m: [0m[1;30mReturn internal state; can be passed to setstate() later.[0m
        [1;34mlognormvariate[0m[1;34m: [0m[1;30mLog normal distribution.[0m
        [1;34mnormalvariate[0m[1;34m: [0m[1;30mNormal distribution.[0m
        [1;34mparetovariate[0m[1;34m: [0m[1;30mPareto distribution.  alpha is the shape parameter.[0m
        [1;34mrandint[0m[1;34m: [0m[1;30mReturn random integer in range [a, b], including both end points.[0m
        [1;34mrandom[0m[1;34m: [0m[1;30mrandom() -> x in the interval [0, 1).[0m
        [1;34mrandrange[0m[1;34m: [0m[1;30mChoose a random item from range(start, stop[, step]).[0m
        [1;34msample[0m[1;34m: [0m[1;30mChooses k unique random elements from a population sequence or set.[0m
        [1;34mseed[0m[1;34m: [0m[1;30mInitialize internal state from hashable object.[0m
        [1;34msetstate[0m[1;34m: [0m[1;30mRestore internal state from object returned by getstate().[0m
        [1;34mshuffle[0m[1;34m: [0m[1;30mShuffle list x in place, and return None.[0m
        [1;34mtriangular[0m[1;34m: [0m[1;30mTriangular distribution.[0m
        [1;34muniform[0m[1;34m: [0m[1;30mGet a random number in the range [a, b) or [a, b] depending on rounding.[0m
        [1;34mvonmisesvariate[0m[1;34m: [0m[1;30mCircular data distribution.[0m
        [1;34mweibullvariate[0m[1;34m: [0m[1;30mWeibull distribution.[0m




```python
[f for f in dir(rn) if f.endswith('variate')]
```




    ['betavariate',
     'expovariate',
     'gammavariate',
     'lognormvariate',
     'normalvariate',
     'paretovariate',
     'vonmisesvariate',
     'weibullvariate']




```python
import numpy as np
dir(np.random).public
```




    [0;35mproperty:[0m
        [1;34mabsolute_import[0m[1;34m, [0m[1;34mdivision[0m[1;34m, [0m[1;34mmtrand[0m[1;34m, [0m[1;34mnp[0m[1;34m, [0m[1;34moperator[0m[1;34m, [0m[1;34mprint_function[0m[1;34m, [0m[1;34mtest[0m[1;34m, [0m[1;34mwarnings[0m
    [0;35mclass:[0m
        [1;34mRandomState[0m[1;34m: [0m[1;30mRandomState(seed=None)[0m
    [0;35mfunction:[0m
        [1;34mLock[0m[1;34m: [0m[1;30mallocate_lock() -> lock object[0m
        [1;34mbeta[0m[1;34m: [0m[1;30mbeta(a, b, size=None)[0m
        [1;34mbinomial[0m[1;34m: [0m[1;30mbinomial(n, p, size=None)[0m
        [1;34mbytes[0m[1;34m: [0m[1;30mbytes(length)[0m
        [1;34mchisquare[0m[1;34m: [0m[1;30mchisquare(df, size=None)[0m
        [1;34mchoice[0m[1;34m: [0m[1;30mchoice(a, size=None, replace=True, p=None)[0m
        [1;34mdirichlet[0m[1;34m: [0m[1;30mdirichlet(alpha, size=None)[0m
        [1;34mexponential[0m[1;34m: [0m[1;30mexponential(scale=1.0, size=None)[0m
        [1;34mf[0m[1;34m: [0m[1;30mf(dfnum, dfden, size=None)[0m
        [1;34mgamma[0m[1;34m: [0m[1;30mgamma(shape, scale=1.0, size=None)[0m
        [1;34mgeometric[0m[1;34m: [0m[1;30mgeometric(p, size=None)[0m
        [1;34mget_state[0m[1;34m: [0m[1;30mget_state()[0m
        [1;34mgumbel[0m[1;34m: [0m[1;30mgumbel(loc=0.0, scale=1.0, size=None)[0m
        [1;34mhypergeometric[0m[1;34m: [0m[1;30mhypergeometric(ngood, nbad, nsample, size=None)[0m
        [1;34mlaplace[0m[1;34m: [0m[1;30mlaplace(loc=0.0, scale=1.0, size=None)[0m
        [1;34mlogistic[0m[1;34m: [0m[1;30mlogistic(loc=0.0, scale=1.0, size=None)[0m
        [1;34mlognormal[0m[1;34m: [0m[1;30mlognormal(mean=0.0, sigma=1.0, size=None)[0m
        [1;34mlogseries[0m[1;34m: [0m[1;30mlogseries(p, size=None)[0m
        [1;34mmultinomial[0m[1;34m: [0m[1;30mmultinomial(n, pvals, size=None)[0m
        [1;34mmultivariate_normal[0m[1;34m: [0m[1;30mmultivariate_normal(mean, cov[, size, check_valid, tol])[0m
        [1;34mnegative_binomial[0m[1;34m: [0m[1;30mnegative_binomial(n, p, size=None)[0m
        [1;34mnoncentral_chisquare[0m[1;34m: [0m[1;30mnoncentral_chisquare(df, nonc, size=None)[0m
        [1;34mnoncentral_f[0m[1;34m: [0m[1;30mnoncentral_f(dfnum, dfden, nonc, size=None)[0m
        [1;34mnormal[0m[1;34m: [0m[1;30mnormal(loc=0.0, scale=1.0, size=None)[0m
        [1;34mpareto[0m[1;34m: [0m[1;30mpareto(a, size=None)[0m
        [1;34mpermutation[0m[1;34m: [0m[1;30mpermutation(x)[0m
        [1;34mpoisson[0m[1;34m: [0m[1;30mpoisson(lam=1.0, size=None)[0m
        [1;34mpower[0m[1;34m: [0m[1;30mpower(a, size=None)[0m
        [1;34mrand[0m[1;34m: [0m[1;30mrand(d0, d1, ..., dn)[0m
        [1;34mrandint[0m[1;34m: [0m[1;30mrandint(low, high=None, size=None, dtype='l')[0m
        [1;34mrandn[0m[1;34m: [0m[1;30mrandn(d0, d1, ..., dn)[0m
        [1;34mrandom[0m[1;34m: [0m[1;30mrandom_sample(size=None)[0m
        [1;34mrandom_integers[0m[1;34m: [0m[1;30mrandom_integers(low, high=None, size=None)[0m
        [1;34mrandom_sample[0m[1;34m: [0m[1;30mrandom_sample(size=None)[0m
        [1;34mranf[0m[1;34m: [0m[1;30mrandom_sample(size=None)[0m
        [1;34mrayleigh[0m[1;34m: [0m[1;30mrayleigh(scale=1.0, size=None)[0m
        [1;34msample[0m[1;34m: [0m[1;30mrandom_sample(size=None)[0m
        [1;34mseed[0m[1;34m: [0m[1;30mseed(seed=None)[0m
        [1;34mset_state[0m[1;34m: [0m[1;30mset_state(state)[0m
        [1;34mshuffle[0m[1;34m: [0m[1;30mshuffle(x)[0m
        [1;34mstandard_cauchy[0m[1;34m: [0m[1;30mstandard_cauchy(size=None)[0m
        [1;34mstandard_exponential[0m[1;34m: [0m[1;30mstandard_exponential(size=None)[0m
        [1;34mstandard_gamma[0m[1;34m: [0m[1;30mstandard_gamma(shape, size=None)[0m
        [1;34mstandard_normal[0m[1;34m: [0m[1;30mstandard_normal(size=None)[0m
        [1;34mstandard_t[0m[1;34m: [0m[1;30mstandard_t(df, size=None)[0m
        [1;34mtriangular[0m[1;34m: [0m[1;30mtriangular(left, mode, right, size=None)[0m
        [1;34muniform[0m[1;34m: [0m[1;30muniform(low=0.0, high=1.0, size=None)[0m
        [1;34mvonmises[0m[1;34m: [0m[1;30mvonmises(mu, kappa, size=None)[0m
        [1;34mwald[0m[1;34m: [0m[1;30mwald(mean, scale, size=None)[0m
        [1;34mweibull[0m[1;34m: [0m[1;30mweibull(a, size=None)[0m
        [1;34mzipf[0m[1;34m: [0m[1;30mzipf(a, size=None)[0m




```python
np.random.negative_binomial(n=2, p=0.5, size=10)
```




    array([1, 2, 0, 2, 0, 8, 1, 0, 5, 3])




```python

```


```python
neg_bin = np.random.negative_binomial(n=10, p=0.5, size=10000)
plt.hist(neg_bin, bins=np.linspace(0, 30, 31));
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_21_0.png)
    



```python
λ = np.random.gamma(10, size=10000)
plt.hist(λ);
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_22_0.png)
    



```python
poi_obs = np.random.poisson(λ)
plt.hist(poi_obs);
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_23_0.png)
    



```python
bins=np.linspace(0, 30, 31)
plt.hist(poi_obs, bins=bins, alpha=0.4);
plt.hist(neg_bin, bins=bins, alpha=0.4);
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_24_0.png)
    



```python

```


```python
import scipy.stats as st
dir(st).properties.public
```




    [0;35mproperty:[0m
        [1;34mabsolute_import[0m[1;34m, [0m[1;34malpha[0m[1;34m, [0m[1;34manglit[0m[1;34m, [0m[1;34marcsine[0m[1;34m, [0m[1;34margus[0m[1;34m, [0m[1;34mbernoulli[0m[1;34m, [0m[1;34mbeta[0m[1;34m, [0m[1;34mbetaprime[0m[1;34m, [0m[1;34mbinom[0m[1;34m, [0m[1;34mboltzmann[0m[1;34m, [0m[1;34mbradford[0m[1;34m, [0m[1;34mburr[0m[1;34m, [0m[1;34mburr12[0m[1;34m, [0m[1;34mcauchy[0m[1;34m, [0m[1;34mchi[0m[1;34m, [0m[1;34mchi2[0m[1;34m, [0m[1;34mcontingency[0m[1;34m, [0m[1;34mcosine[0m[1;34m, [0m[1;34mcrystalball[0m[1;34m, [0m[1;34mdgamma[0m[1;34m, [0m[1;34mdirichlet[0m[1;34m, [0m[1;34mdistributions[0m[1;34m, [0m[1;34mdivision[0m[1;34m, [0m[1;34mdlaplace[0m[1;34m, [0m[1;34mdweibull[0m[1;34m, [0m[1;34merlang[0m[1;34m, [0m[1;34mexpon[0m[1;34m, [0m[1;34mexponnorm[0m[1;34m, [0m[1;34mexponpow[0m[1;34m, [0m[1;34mexponweib[0m[1;34m, [0m[1;34mf[0m[1;34m, [0m[1;34mfatiguelife[0m[1;34m, [0m[1;34mfisk[0m[1;34m, [0m[1;34mfoldcauchy[0m[1;34m, [0m[1;34mfoldnorm[0m[1;34m, [0m[1;34mfrechet_l[0m[1;34m, [0m[1;34mfrechet_r[0m[1;34m, [0m[1;34mgamma[0m[1;34m, [0m[1;34mgausshyper[0m[1;34m, [0m[1;34mgenexpon[0m[1;34m, [0m[1;34mgenextreme[0m[1;34m, [0m[1;34mgengamma[0m[1;34m, [0m[1;34mgenhalflogistic[0m[1;34m, [0m[1;34mgenlogistic[0m[1;34m, [0m[1;34mgennorm[0m[1;34m, [0m[1;34mgenpareto[0m[1;34m, [0m[1;34mgeom[0m[1;34m, [0m[1;34mgilbrat[0m[1;34m, [0m[1;34mgompertz[0m[1;34m, [0m[1;34mgumbel_l[0m[1;34m, [0m[1;34mgumbel_r[0m[1;34m, [0m[1;34mhalfcauchy[0m[1;34m, [0m[1;34mhalfgennorm[0m[1;34m, [0m[1;34mhalflogistic[0m[1;34m, [0m[1;34mhalfnorm[0m[1;34m, [0m[1;34mhypergeom[0m[1;34m, [0m[1;34mhypsecant[0m[1;34m, [0m[1;34minvgamma[0m[1;34m, [0m[1;34minvgauss[0m[1;34m, [0m[1;34minvweibull[0m[1;34m, [0m[1;34minvwishart[0m[1;34m, [0m[1;34mjohnsonsb[0m[1;34m, [0m[1;34mjohnsonsu[0m[1;34m, [0m[1;34mkappa3[0m[1;34m, [0m[1;34mkappa4[0m[1;34m, [0m[1;34mkde[0m[1;34m, [0m[1;34mksone[0m[1;34m, [0m[1;34mkstwobign[0m[1;34m, [0m[1;34mlaplace[0m[1;34m, [0m[1;34mlevy[0m[1;34m, [0m[1;34mlevy_l[0m[1;34m, [0m[1;34mlevy_stable[0m[1;34m, [0m[1;34mloggamma[0m[1;34m, [0m[1;34mlogistic[0m[1;34m, [0m[1;34mloglaplace[0m[1;34m, [0m[1;34mlognorm[0m[1;34m, [0m[1;34mlogser[0m[1;34m, [0m[1;34mlomax[0m[1;34m, [0m[1;34mmatrix_normal[0m[1;34m, [0m[1;34mmaxwell[0m[1;34m, [0m[1;34mmielke[0m[1;34m, [0m[1;34mmorestats[0m[1;34m, [0m[1;34mmoyal[0m[1;34m, [0m[1;34mmstats[0m[1;34m, [0m[1;34mmstats_basic[0m[1;34m, [0m[1;34mmstats_extras[0m[1;34m, [0m[1;34mmultinomial[0m[1;34m, [0m[1;34mmultivariate_normal[0m[1;34m, [0m[1;34mmvn[0m[1;34m, [0m[1;34mnakagami[0m[1;34m, [0m[1;34mnbinom[0m[1;34m, [0m[1;34mncf[0m[1;34m, [0m[1;34mnct[0m[1;34m, [0m[1;34mncx2[0m[1;34m, [0m[1;34mnorm[0m[1;34m, [0m[1;34mnorminvgauss[0m[1;34m, [0m[1;34mortho_group[0m[1;34m, [0m[1;34mpareto[0m[1;34m, [0m[1;34mpearson3[0m[1;34m, [0m[1;34mplanck[0m[1;34m, [0m[1;34mpoisson[0m[1;34m, [0m[1;34mpowerlaw[0m[1;34m, [0m[1;34mpowerlognorm[0m[1;34m, [0m[1;34mpowernorm[0m[1;34m, [0m[1;34mprint_function[0m[1;34m, [0m[1;34mrandint[0m[1;34m, [0m[1;34mrandom_correlation[0m[1;34m, [0m[1;34mrayleigh[0m[1;34m, [0m[1;34mrdist[0m[1;34m, [0m[1;34mrecipinvgauss[0m[1;34m, [0m[1;34mreciprocal[0m[1;34m, [0m[1;34mrice[0m[1;34m, [0m[1;34msemicircular[0m[1;34m, [0m[1;34mskellam[0m[1;34m, [0m[1;34mskewnorm[0m[1;34m, [0m[1;34mspecial_ortho_group[0m[1;34m, [0m[1;34mstatlib[0m[1;34m, [0m[1;34mstats[0m[1;34m, [0m[1;34mt[0m[1;34m, [0m[1;34mtest[0m[1;34m, [0m[1;34mtrapz[0m[1;34m, [0m[1;34mtriang[0m[1;34m, [0m[1;34mtruncexpon[0m[1;34m, [0m[1;34mtruncnorm[0m[1;34m, [0m[1;34mtukeylambda[0m[1;34m, [0m[1;34muniform[0m[1;34m, [0m[1;34munitary_group[0m[1;34m, [0m[1;34mvonmises[0m[1;34m, [0m[1;34mvonmises_line[0m[1;34m, [0m[1;34mwald[0m[1;34m, [0m[1;34mweibull_max[0m[1;34m, [0m[1;34mweibull_min[0m[1;34m, [0m[1;34mwishart[0m[1;34m, [0m[1;34mwrapcauchy[0m[1;34m, [0m[1;34myulesimon[0m[1;34m, [0m[1;34mzipf[0m




```python
dir(st.gamma).public
```




    [0;35mproperty:[0m
        [1;34ma[0m[1;34m, [0m[1;34mb[0m[1;34m, [0m[1;34mbadvalue[0m[1;34m, [0m[1;34mextradoc[0m[1;34m, [0m[1;34mgeneric_moment[0m[1;34m, [0m[1;34mmoment_type[0m[1;34m, [0m[1;34mname[0m[1;34m, [0m[1;34mnumargs[0m[1;34m, [0m[1;34mshapes[0m[1;34m, [0m[1;34mvecentropy[0m[1;34m, [0m[1;34mxtol[0m
    [0;35mdescriptor:[0m
        [1;34mrandom_state[0m[1;34m: [0m[1;30m@property with getter, setter, Get or set the RandomState object for generating random variates.[0m
    [0;35mfunction:[0m
        [1;34mcdf[0m[1;34m: [0m[1;30mCumulative distribution function of the given RV.[0m
        [1;34mentropy[0m[1;34m: [0m[1;30mDifferential entropy of the RV.[0m
        [1;34mexpect[0m[1;34m: [0m[1;30mCalculate expected value of a function with respect to the[0m
        [1;34mfit[0m[1;34m: [0m[1;30mReturn MLEs for shape (if applicable), location, and scale[0m
        [1;34mfit_loc_scale[0m[1;34m: [0m[1;30mEstimate loc and scale parameters from data using 1st and 2nd moments.[0m
        [1;34mfreeze[0m[1;34m: [0m[1;30mFreeze the distribution for the given arguments.[0m
        [1;34minterval[0m[1;34m: [0m[1;30mConfidence interval with equal areas around the median.[0m
        [1;34misf[0m[1;34m: [0m[1;30mInverse survival function (inverse of `sf`) at q of the given RV.[0m
        [1;34mlogcdf[0m[1;34m: [0m[1;30mLog of the cumulative distribution function at x of the given RV.[0m
        [1;34mlogpdf[0m[1;34m: [0m[1;30mLog of the probability density function at x of the given RV.[0m
        [1;34mlogsf[0m[1;34m: [0m[1;30mLog of the survival function of the given RV.[0m
        [1;34mmean[0m[1;34m: [0m[1;30mMean of the distribution.[0m
        [1;34mmedian[0m[1;34m: [0m[1;30mMedian of the distribution.[0m
        [1;34mmoment[0m[1;34m: [0m[1;30mn-th order non-central moment of distribution.[0m
        [1;34mnnlf[0m[1;34m: [0m[1;30mReturn negative loglikelihood function.[0m
        [1;34mpdf[0m[1;34m: [0m[1;30mProbability density function at x of the given RV.[0m
        [1;34mppf[0m[1;34m: [0m[1;30mPercent point function (inverse of `cdf`) at q of the given RV.[0m
        [1;34mrvs[0m[1;34m: [0m[1;30mRandom variates of given type.[0m
        [1;34msf[0m[1;34m: [0m[1;30mSurvival function (1 - `cdf`) at x of the given RV.[0m
        [1;34mstats[0m[1;34m: [0m[1;30mSome statistics of the given RV.[0m
        [1;34mstd[0m[1;34m: [0m[1;30mStandard deviation of the distribution.[0m
        [1;34mvar[0m[1;34m: [0m[1;30mVariance of the distribution.[0m



all thes distributions are described using a **location** and **scale** parameter, and, if necessary, one or more **shape** parameters.

Basically they can describe all translation and scaling of the basic function.

This is usually different from the traditional parametrization, and this can lead to some problems here and there


```python
help(st.gamma.rvs)
```

    Help on method rvs in module scipy.stats._distn_infrastructure:
    
    rvs(*args, **kwds) method of scipy.stats._continuous_distns.gamma_gen instance
        Random variates of given type.
        
        Parameters
        ----------
        arg1, arg2, arg3,... : array_like
            The shape parameter(s) for the distribution (see docstring of the
            instance object for more information).
        loc : array_like, optional
            Location parameter (default=0).
        scale : array_like, optional
            Scale parameter (default=1).
        size : int or tuple of ints, optional
            Defining number of random variates (default is 1).
        random_state : None or int or ``np.random.RandomState`` instance, optional
            If int or RandomState, use it for drawing the random variates.
            If None, rely on ``self.random_state``.
            Default is None.
        
        Returns
        -------
        rvs : ndarray or scalar
            Random variates of given `size`.
    


these distributions can be used in frozen or unfrozen state.

a frozen distribution has its parameters fixed, while an unfrozen one requires them every time


```python
st.gamma.rvs(2.0, loc=0, scale=1, size=3)
```




    array([1.26527731, 2.04624127, 0.59565769])




```python
dist = st.gamma(2.0, loc=0, scale=1)
dist.rvs(3)
```




    array([0.42775444, 1.07160098, 0.92292052])




```python
x = np.linspace(0, 5, 1000)
pdf_value = dist.pdf(x)
plt.plot(x, pdf_value)
```




    [<matplotlib.lines.Line2D at 0x7feb87a60358>]




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_33_1.png)
    



```python
dist = st.gamma(2.0, loc=0, scale=1)
data = dist.rvs(30)
```


```python
st.gamma.fit(data)
# alpha, location and scale
```




    (0.38060160599369985, 0.6906977809779535, 3.7548729912059065)



location is a shift, and it might not be appropriate for distributions like the gamma!
the fit method allow us to fix it to a certain value


```python
st.gamma.fit(data, floc=0)
# alpha, location and scale
```




    (2.5961195947728815, 0, 0.909155266176654)



the result is clearly better!


```python
params = st.gamma.fit(data, floc=0)
new_dist = st.gamma(*params)
```


```python
sns.distplot(dist.rvs(10_000))
sns.distplot(new_dist.rvs(10_000))
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb87b6a470>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_40_1.png)
    


one can notice that the histogram is incorrect, as is doing a kernel density estimation and it has borders that go below zero...

seaborn allows us to use an arbitrary function for showing the distribution, that has to follow the same interface as a scipy distribution:

* a **fit** function that returns a tuple of parameters
* a **pdf** function that takes the parameters and the x positions and returns the pdf values

we could use the distributions directly, but seaborn does not yet allow to configure the fit to remove the location (it should do in the next version after the 0.9), so we have to implement it ourselves


```python
data_norm = np.random.randn(1000)
sns.distplot(data_norm, kde=False, fit=st.norm)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7df8fb00>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_42_1.png)
    



```python
class GammaFitter:
    def fit(self, data):
        return st.gamma.fit(data, floc=0)
    
    def pdf(self, x, *params):
        return st.gamma.pdf(x, *params)
    
sbn.distplot(dist.rvs(10_000), kde=False, fit=GammaFitter())
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb87777ef0>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_43_1.png)
    


## Exercise 1

try to implement a more generic fitter for seaborn, that allow to choose wich parameters to fix and can be used, and make it extendible to other distributions of the same kind


```python
class Fitter:
    pass # your code here

myfitter_1 = Fitter(distribution=st.gamma, floc=0)
myfitter_2 = Fitter(distribution=st.norm)

my_fitter = myfitter_1

data = np.random.gammavariate(2.0, size=10_000)
sbn.distplot(data, kde=False, fit=myfitter)
```


```python
class Fitter:
    def __init__(self, distribution):
        self.dist = distribution
        
    def fit(self, data):
        return self.dist.fit(data, floc=0)
    
    def pdf(self, x, *params):
        return self.dist.pdf(x, *params)

myfitter_1 = Fitter(distribution=st.gamma, floc=0)
myfitter_2 = Fitter(distribution=st.norm)

my_fitter = myfitter_1

data = np.random.gammavariate(2.0, size=10_000)
sbn.distplot(data, kde=False, fit=myfitter)
```


```python
def my_fun(a, *args, b=1, **kws):
    print(args)
    print(kws)
    
my_fun(1, 2, 3, c=3, d=5)
```

    (2, 3)
    {'c': 3, 'd': 5}



```python
def my_fun_2(a, b):
    print(a, b)
    
values = {'a':1, 'b':2}
my_fun_2(**values)
# my_fun_2(a=values['a'], b=values['b'])
```

    1 2



```python
class Fitter:
    def __init__(self, distribution, **fit_params):
        self.distribution = distribution
        self.fit_params = fit_params
        
    def fit(self, data):
        params = self.fit_params
        return self.distribution.fit(data, **params)
    
    def pdf(self, x, *params):
        return self.distribution.pdf(x, *params)

myfitter_1 = Fitter(distribution=st.gamma, floc=0)
myfitter_3 = Fitter(distribution=st.gamma)

myfitter_2 = Fitter(distribution=st.norm)

my_fitter = myfitter_3

data = st.gamma.rvs(2.0, size=10_000)
sbn.distplot(data, kde=False, fit=my_fitter)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7dcca198>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_49_1.png)
    



```python
## HINT
floc = None # or a value
kws = {}
if floc is not None:
    kws = {'floc': floc}
st.gamma.fit(data, **kws)
```




    (0.38060160599369985, 0.6906977809779535, 3.7548729912059065)



## Visualizing the ECDF (Empirical cumulative distribution function)


```python
data = plt.randn(4)
data
```




    array([-0.6561222 ,  1.02863093, -0.3788329 ,  0.02472737])




```python
sns.distplot(data, hist=True, kde=False);
sns.rugplot(data, height=0.1, linewidth=3, color='r');
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_53_0.png)
    



```python
data_sorted = np.sort(data)
index = np.linspace(0, 1, len(data_sorted))
plt.plot(data_sorted, index, linestyle='steps-pre')
sns.rugplot(data, height=0.1, 
            linewidth=3, color='r');
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_54_0.png)
    


this is a reasonable visualization, but when we are going to use it later, the behavior is going to be closer to this:


```python
data_sorted = np.sort(data)
index = np.linspace(0, 1, len(data_sorted))
plt.plot(data_sorted, index, linestyle='steps-post')
sns.rugplot(data, height=0.1, linewidth=3, color='r');
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_56_0.png)
    


to reduce the borders effect, it is better to adjust how we estimate the indexes


```python
np.linspace(0, 1, 4)
```




    array([0.        , 0.33333333, 0.66666667, 1.        ])




```python
np.linspace(0, 1, 4+1)
```




    array([0.  , 0.25, 0.5 , 0.75, 1.  ])




```python
np.linspace(0, 1, 4+1)[1:]
```




    array([0.25, 0.5 , 0.75, 1.  ])




```python
np.linspace(1/4, 1, 4)
```




    array([0.25, 0.5 , 0.75, 1.  ])




```python
data_sorted = np.sort(data)

index = np.linspace(0, 1, 1+len(data_sorted))
index = index[1:]

plt.plot(data_sorted, index, linestyle='steps-post')
sns.rugplot(data, height=0.1, linewidth=3, color='r');
plt.ylim(0,1)
```




    (0, 1)




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_62_1.png)
    



```python
def plot_ecdf(data, ax=None, **plot_kws):
    if ax is None:
        ax = plt.gca()
    data_sorted = np.sort(data)
    index = np.linspace(0, 1, 1+len(data_sorted))[1:]
    ax.plot(data_sorted, index, linestyle='steps-post', **plot_kws)
```


```python
plot_ecdf(plt.randn(100), color='r')
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_64_0.png)
    



```python
data = (5+plt.randn(100)*5)**2
data_sorted = np.sort(data)
est_ecdf = np.linspace(0, 1, len(data_sorted)+1)[1:]

dist = st.gamma
params = dist.fit(data_sorted)
frozen = dist(*params)
teo_ecdf = 1-frozen.sf(data_sorted)
```


```python
fig, (ax0, ax1, ax2) = plt.subplots(1, 3, figsize=(18, 6))

counts, bins, _ = ax0.hist(data, density=True, alpha=0.5, bins=40)
x = np.linspace(0, np.max(bins))
ax0.plot(x, frozen.pdf(x))
ax0.set_title("histogram plot")

ax1.plot(data_sorted, teo_ecdf, color='b')
ax1.plot(data_sorted, est_ecdf, color='r')
ax1.set_title("ecdf plot")

ax2.scatter(teo_ecdf, est_ecdf)
ax2.plot(teo_ecdf, teo_ecdf, color='r')
ax2.set_title("quantile quantile plot")
```




    Text(0.5, 1.0, 'quantile quantile plot')




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_66_1.png)
    



```python
data = (5+plt.randn(100))**2

dist = st.norm
params = dist.fit(data)
frozen = dist(*params)

for i in range(100):
    fake_data = frozen.rvs(len(data))
    plot_ecdf(fake_data, color='r', alpha=0.05, linewidth=3)
plot_ecdf(data, linewidth=3)
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_67_0.png)
    


## Generating numbers with the ECDF


```python
plt.rand()
```




    0.13041370191935675




```python
data = (5+plt.randn(100))**2
data_sorted = np.sort(data)
est_ecdf = np.linspace(0, 1, 1+len(data_sorted))[1:]
```


```python
np.searchsorted([0.25, 0.5, 1], 0.15)
```




    0




```python
est_ecdf
```




    array([0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1 , 0.11,
           0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2 , 0.21, 0.22,
           0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3 , 0.31, 0.32, 0.33,
           0.34, 0.35, 0.36, 0.37, 0.38, 0.39, 0.4 , 0.41, 0.42, 0.43, 0.44,
           0.45, 0.46, 0.47, 0.48, 0.49, 0.5 , 0.51, 0.52, 0.53, 0.54, 0.55,
           0.56, 0.57, 0.58, 0.59, 0.6 , 0.61, 0.62, 0.63, 0.64, 0.65, 0.66,
           0.67, 0.68, 0.69, 0.7 , 0.71, 0.72, 0.73, 0.74, 0.75, 0.76, 0.77,
           0.78, 0.79, 0.8 , 0.81, 0.82, 0.83, 0.84, 0.85, 0.86, 0.87, 0.88,
           0.89, 0.9 , 0.91, 0.92, 0.93, 0.94, 0.95, 0.96, 0.97, 0.98, 0.99,
           1.  ])




```python
p = plt.rand()
idx = np.searchsorted(est_ecdf, p)
val = data_sorted[idx]
val
```




    20.115462913749713




```python
p = plt.rand(10)
idx = np.searchsorted(est_ecdf, p)
val = data_sorted[idx]
val
```




    array([28.78496923, 31.64769229, 35.78583449, 35.78583449, 32.61468568,
           20.35828101, 16.95870004, 18.15856544, 35.78583449, 18.14873844])




```python
p = plt.rand(100_000)
idx = np.searchsorted(est_ecdf, p)
generated = data_sorted[idx]
```


```python
sns.distplot(data, hist=False, kde=False, rug=True);
sns.distplot(generated, hist=True, kde=False, rug=False);
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_76_0.png)
    



```python
1-st.norm.isf(0.3)
```




    0.4755994872919591




```python
p = plt.rand(100_000)
norm_data = 1-st.norm.isf(p)
sns.distplot(norm_data)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7eef56d8>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_78_1.png)
    


## Monte Carlo methods

a collection of methods that uses random sequences to estimate the average value of some specific functions, often integrals.

we saw an example of this when we estimated the value of $\pi$ using random numbers

$$ \int_{[0,1]^s} f(u)\,{\rm d}u \approx \frac{1}{N}\,\sum_{i=1}^N f(x_i). $$

the rate of convergence by using N random numbers is $O\left(\frac{1}{\sqrt{N}}\right)$

There are better methods for exploring a function if we can, and that is by using **low-discrepancy sequences**.

These are sequences that looks quite random, but do not tend to cluster as random numbers do, covering the space in a more uniform way.

low-discrepancy sequences converge with $O\left(\frac{1}{N}\right)$, but they are a little more difficult to implement.

These methods are called quasi-Monte Carlo, as they are not using proper pseudo-random numbers


```python
p = plt.rand(100)
norm_data = 1-st.norm.isf(p)
sns.distplot(norm_data)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7f0082e8>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_81_1.png)
    



```python
p = np.linspace(1/100, 1-1/100, 100)
norm_data = 1-st.norm.isf(p)
sns.distplot(norm_data)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7d2a6550>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_82_1.png)
    



```python
N = 100
p = plt.rand(N)
norm_data_rand = 1-st.norm.isf(p)
p = np.linspace(1/N, 1-1/N, N)
norm_data_samp = 1-st.norm.isf(p)
sns.distplot(norm_data_rand, color='r')
sns.distplot(norm_data_samp, color='b')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7d2a00f0>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_83_1.png)
    


The simplest low-discrepancy sequence is the **Van der Corput sequence**, and is quite easy to implement:

the denominators are increasing powers of the base, the numerators are all the values in that base, but sorted base on the last digit (skipping the numbers that ends in 0, as they would simplify and recreate previous ones)

$$\left\{ \tfrac{1}{10}, \tfrac{2}{10}, \tfrac{3}{10}, \tfrac{4}{10}, \tfrac{5}{10}, \tfrac{6}{10}, \tfrac{7}{10}, \tfrac{8}{10}, \tfrac{9}{10}, \tfrac{01}{100}, \tfrac{11}{100}, \tfrac{21}{100}, \tfrac{31}{100}, \tfrac{41}{100}, \tfrac{51}{100}, \tfrac{61}{100}, \tfrac{71}{100}, \tfrac{81}{100}, \tfrac{91}{100}, \tfrac{02}{100}, \tfrac{12}{100}, \tfrac{22}{100}, \tfrac{32}{100}, \ldots \right\}$$


```python
def vdc(n, base=2):
    vdc = 0
    denom = 1
    while n:
        denom *= base
        n, remainder = divmod(n, base)
        vdc += remainder / denom
    return vdc

def avdn(n, base=10):
    return np.array([vdc(i, base=base) for i in range(1, n+1)])
```


```python
avdn(11)
```




    array([0.1 , 0.2 , 0.3 , 0.4 , 0.5 , 0.6 , 0.7 , 0.8 , 0.9 , 0.01, 0.11])




```python
from fractions import Fraction
[vdc(i, base=Fraction(10)) for i in range(1, 11)]
```




    [Fraction(1, 10),
     Fraction(1, 5),
     Fraction(3, 10),
     Fraction(2, 5),
     Fraction(1, 2),
     Fraction(3, 5),
     Fraction(7, 10),
     Fraction(4, 5),
     Fraction(9, 10),
     Fraction(1, 100)]




```python
avdn(11, base=2)
```




    array([0.5   , 0.25  , 0.75  , 0.125 , 0.625 , 0.375 , 0.875 , 0.0625,
           0.5625, 0.3125, 0.8125])




```python
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))
bins = np.linspace(0, 1, 21)
ax1.hist(np.random.rand(1000), bins=bins)
ax2.hist(avdn(1000), bins=bins);
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_89_0.png)
    


being a uniform sample generator, one can then use this to generate arbitrary random variables!

for example, to combined them to generate normally distributed data, we can use the **isf** function of the distributions!


```python
st.norm.isf(0.2)
```




    0.8416212335729142




```python
st.norm.isf(0.9)
```




    -1.2815515655446004




```python
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))
ax1.hist(plt.randn(1000), bins=50);

vdn_sample = avdn(1000)
gaussian_samples = st.norm.isf(vdn_sample)
ax2.hist(gaussian_samples, bins=50);
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_94_0.png)
    


the Van der Corput sequence can be generalized to multiple dimensions at the same time by the **Halton sequence**, that is generated in a similar fashion

A general library to generate these sequences in high dimensions is provided by the library **SALib**.

You won't need it for today, but for real use, where the number of dimensions is high, it might be worth using it.


```python
from SALib.sample import saltelli
```


```python
problem = {
    'num_vars': 2,
    'names': ['x1', 'x2'],
    'bounds': [[0, 1],
               [0, 1],]
}
```


```python
param_values = saltelli.sample(problem, 100)
```


```python
plt.scatter(*param_values.T)
```




    <matplotlib.collections.PathCollection at 0x7feb8047e588>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_100_1.png)
    


## sensitivity analysis of ODE with random numbers


```python
from scipy.integrate import odeint

def exponential_deriv(state, time, alpha):
    return -alpha*state

time = np.linspace(0, 5, 21)
y0 = 1
α = 0.3
```


```python
res = odeint(exponential_deriv, y0=y0, t=time, args=(α, ))
```


```python
res
```




    array([[1.        ],
           [0.92774351],
           [0.860708  ],
           [0.79851623],
           [0.7408182 ],
           [0.68728927],
           [0.63762818],
           [0.59155538],
           [0.54881165],
           [0.50915644],
           [0.47236657],
           [0.43823501],
           [0.40656968],
           [0.37719238],
           [0.34993777],
           [0.32465248],
           [0.30119421],
           [0.27943097],
           [0.25924026],
           [0.24050846],
           [0.22313016]])




```python
res = pd.DataFrame(res, columns=['y'])
res['time'] = time
res['α'] = α

res.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>y</th>
      <th>time</th>
      <th>α</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.000000</td>
      <td>0.00</td>
      <td>0.3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.927744</td>
      <td>0.25</td>
      <td>0.3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.860708</td>
      <td>0.50</td>
      <td>0.3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.798516</td>
      <td>0.75</td>
      <td>0.3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.740818</td>
      <td>1.00</td>
      <td>0.3</td>
    </tr>
  </tbody>
</table>
</div>




```python
plt.scatter(x='time', y='y', data=res)
```




    <matplotlib.collections.PathCollection at 0x7feb7f94c048>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_106_1.png)
    



```python
def exponential_deriv(state, time, alpha):
    return -alpha*state

time = np.linspace(0, 5, 2**4+1)
results = []
alphas = np.exp(np.random.randn(20)*0.1)

for idx, α in enumerate(alphas):
    res = odeint(exponential_deriv, y0=1, t=time, args=(α, ))
    res = pd.DataFrame(res, columns=['y'])
    res['time'] = time
    res['α'] = α
    res['simulation_run'] = idx
    results.append(res)
results = pd.concat(results)
```


```python
results.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>y</th>
      <th>time</th>
      <th>α</th>
      <th>simulation_run</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.000000</td>
      <td>0.0000</td>
      <td>0.902178</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.754326</td>
      <td>0.3125</td>
      <td>0.902178</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.569008</td>
      <td>0.6250</td>
      <td>0.902178</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.429217</td>
      <td>0.9375</td>
      <td>0.902178</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.323770</td>
      <td>1.2500</td>
      <td>0.902178</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




```python
sns.distplot(alphas);
```


    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_109_0.png)
    



```python
sns.lineplot("time", 'y', data=results, 
             estimator=None, 
             units='simulation_run', 
             hue='α')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7d17b828>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_110_1.png)
    



```python
sns.lineplot("time", 'y', data=results.query("time>0.5 and time<2"),
             estimator=None,
             units='simulation_run',
             hue='α')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7d0b9ba8>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_111_1.png)
    



```python
def exponential_deriv(state, time, alpha):
    return -alpha*state

time = np.linspace(0, 5, 2**4+1)
results = []

vdn_sample = avdn(20)
gaussian_samples = st.norm.isf(vdn_sample)
alphas = np.exp(gaussian_samples*0.1)
    
for idx, α in enumerate(alphas):
    res = odeint(exponential_deriv, y0=1, t=time, args=(α, ))
    res = pd.DataFrame(res, columns=['y'])
    res['time'] = time
    res['α'] = α
    res['simulation_run'] = idx
    results.append(res)
results = pd.concat(results)
```


```python
sns.distplot(alphas)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7d21def0>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_113_1.png)
    



```python
sns.lineplot("time", 'y', data=results, estimator=None, units='simulation_run', hue='α')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7cf63208>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_114_1.png)
    



```python
sns.lineplot("time", 'y', data=results.query("time>0.5 and time<2"),
             estimator=None, units='simulation_run', hue='α')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7feb7cf1d358>




    
![png](Lesson_AF_01_random_generation_and_montecarlo_files/Lesson_AF_01_random_generation_and_montecarlo_115_1.png)
    



```python

```

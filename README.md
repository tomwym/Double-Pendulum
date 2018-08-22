# Double-Pendulum

This repo contains research and development that will go toward developing a model for a double pendulum, and if possible, a multi-bodied pendulum. I began this journey in April 2018, during exams (which was probably a mistake) and since then have made some progess, however the more I researched the further down the rabbit hole it brought me and spoiler: a double pendulum pretty complicated. 

# What is a double pendulum? 
A double pendulum is a pendulum that contains two masses separated by two massless, rigid rods. What is neat about a double pendulum is that it is representitive of chaos. This means the motion is very sensitive to the initial conditions of the system. Perfectly described by James Clerk Maxwell in the following:  

"« There is a maxim…that the same causes will always produce the same effects [...] There is another maxim which must not be confounded with the first, which asserts that “like causes produce like effects. This is only true when small variations  in the initial circumstances produce only small variations in the final state of the system. In a great many physical phenomena this condition is satisfied; but there are other cases in which  a small initial variation may produce a very great change in the final state of the system. »" - James Clerk Maxwell


# Road Map
The road map I have set for this problem is as follows:  
-Research the kinematic motion of a single pendulum  
-Develop a model of a simple/linear pendulum  
-Research the numerical methods required to solve for the equation of a non-linear single pendulum (MATLAB's ODE45 should suffice)  
-Develop a model of a non-linear single pendulum  
-Compare the non-linear pendulum with the linear pendulum  <- where I am now 

-Research the kinematics of a double pendulum (LaGrange framework)  
-Research the numerical methods to solve the system of ODEs (will likely use RK78, as suggested by a professor)  
-Develop a MATLAB model of the double-pendulum and consider accuracy with various numerical solves  

# Single-Non-Simplified-Pendulum
I want to preface this by expressing the unexpected complexity of a single pendulum. 
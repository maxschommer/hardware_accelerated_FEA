# Hardware Accelerated Finite Element Analysis

Finite Element Analysis is a foundational tool for many engineers. Traditionally, if an engineer wants to do a calculation on the maximum amount of stress, strain, heat flux, etc. in a material or object, they would need to make simplifying assumptions until the object became amenable to hand calculations. Finite Element Analysis is a computational techniqe that allows analysis of parts with complex geometries, without any simplifying assumptions needing to be made. Engineers can design arbitrarily complex parts or systems, and be guaranteed that analysis is possible. 

This technique gave rise to the concept of generative design. Generative design is based on repeated application of FEA. A part is described by a set of constraints instead of definite geometry. Analysis is then performed on a block of material that fulfills the spacial constraints, and then material that isn't necessary for the load constraints is removed iteratively. Generative design has the potential to automate much of the engineering process. One significant downside is the amount of time it takes to perform FEA on a part. One part can take anywhere from 1 minute to several hours to analyze properly depending on precision needs.

Our goal is to perform analysis on a part in a few hundred or thousand clock cycles, rather than minutes or hours. We want to make the primary bottleneck of FEA the meshing process, so that generative algorithms can complete in seconds rather than hours. To do this we designed a system to perform FEA using an application specific integrated circuit (ASIC). We designed a system to solve the one dimensional heat equation, and a scheme to generalize our solution to three dimensions, and other types of differential equations. 

## Architectural Description

![Mesh](Media/meshExample.png)

*An example of a 3 dimensional mesh at various resolutions. Note that the mesh consists of nodes (the dots) connected by edges (the lines).*

FEA generally operates on a mesh of the part. A mesh is typically generated from a more precise description of part in order to make a discrete approximation so that analysis on a large but *finite* number of elements can be performed (hence the name Finite Element Analysis). This mesh can be one, two or three dimensional depending on the type of problem being analyzed. A mesh consists of a series of nodes with edges in between them designating connections to other nodes. Most algorithms comprise of applying some function on each node which is dependent on the values of the surrounding nodes (nodes which are connected by edges) and it's own value, and maybe some number of derivatives (i.e. the change in surrounding nodes values, or change in it's own value). These functions are typically very simple and linear, meaning they approximate the solution to a differential equation in a similar way to Eulers's method, using many linear approximations with small time steps.

In order to emulate this technique in hardware, our architecture is based on a series of nodes as well which perform these computations. Each node is capable of connecting to other nodes through a technique we will describe later, and thus simulate any mesh connection. 

### 1 Dimensional Architecture

We will be starting with solving the 1 dimensional heat equation. The heat equation is a partial differential equation defined by:

![Heat Equation 1 Dimensional](Media/heatEqn1D.png)

In order to approximate a solution to this equation, we need to discretize it. This entails taking the linear terms of the Taylor series around T[t,j]. The discretization is the following:

![Discrete Heat Equation 1 Dimensional](Media/discreteHeatEqn1D.png)


Note that each T[t,j] relies on the nodes to the left, T[t,j-1], and right, T[t,j+1], as well as the node value itself. Our nodes implemented in hardware contain registers which model the node's internal temperature and current position. Each node is connected to nodes to the left and right of itself (since there is one dimension) except for the two end point nodes. The nodes share positions as well as their internal values, which allows each to calculate *dx* as well as the change in temperature. 

![Node Architecture](Media/nodesLinear.png)

*The layout of our 1 dimensional nodes, connected togeather sharing information between them.*

We were able to successfuly simulate the 1 dimensional heat equation in verilog using this architecture. To compile, run and plot the simulation simply run `nodes_sol.sh` from the `/Nodes` directory. This should produce an animation similar to the following:

![Example Simulation of the 1 Dimensional Heat Equation Using Verilog](Media/exampleSim.gif)

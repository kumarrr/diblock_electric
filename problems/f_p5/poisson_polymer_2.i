#
# Simulation of Cahn-Hilliard with Electric Fiels introduced by local concentration dependent dielectric functions.
#

[Mesh]
  type = GeneratedMesh
  dim = 3
#  elem_type = QUAD4
  nx = 32
  ny = 32
  nz = 32
  xmin = 0
  xmax = 64
  ymin = 0
  ymax = 64
  zmin = 0
  zmax = 64
  #uniform_refine = 2
[]

[Variables]
  [./phi]   # 2 * (f - phi_A) 
    order = FIRST
    family = LAGRANGE
  [../]
  [./w]   # Chemical potential
    order = FIRST
    family = LAGRANGE
  [../]
 
 [./pseudopsi]   # electric potential
    order = FIRST
    family = LAGRANGE
  [../]

  [./psi]   # electric potential
    order = FIRST
    family = LAGRANGE
  [../]

[]

[ICs]
  [./concentrationIC]   # phi with variations
    type = RandomIC
    min = -0.05
    max = 0.05
    seed = 210
    variable = phi
  [../]
[]

[BCs]
  [./Periodic]
    [./c_bcs]
      auto_direction = 'x y'
    [../]
  [../]
  [./z_positive_potential]
     type = DirichletBC
     variable = psi
     boundary = 'front'
     value = 10.0
  [../]
  [./z_negative_potential]
     type = DirichletBC
     variable = psi
     boundary = 'back'
     value = -10.0
  [../]

[]

[Kernels]
  [./w_dot]
    type = CoupledTimeDerivative
    variable = w
    v = phi
  [../]
  [./coupled_res]
    variable = w
    type = SplitCHWRes
    mob_name = M
  [../]
  [./long_order]
    variable = w
    type = MatReaction
    mob_name = c
    v = pseudopsi
  [../]
#  [./electric_field]
#    variable = w
#    type = CoupledMatAnisoDiffusion
#    tensor_coeff = '0.0  0  0
#              0  0  0
#              0  0  0.1' 
#    v = phi
#  [../]
  [./noise]
    variable = w
    type = LangevinNoise
    amplitude = 0.01
  [../]
  [./coupled_parsed]
    variable = phi
    type = SplitCHParsed
    f_name = f_local
    kappa_name = D
    w = w
  [../]
  [./electric_field]
    type = MatGradSquareCoupled
    variable = phi
    elec_potential = psi
    prefactor = equielec_strength
#    args = phi
  [../]
  [./Poisson_equation]
    variable = psi
    type = DarcyPressure
  [../]
[./Pseudo_Poisson]
    type = Diffusion
    variable = pseudopsi
  [../]
  [./RHS]
    type = ADBodyForcepseudo
    variable = pseudopsi
  [../]
  
 

[]

[Materials]
  [film]
    type = DielectricFilm
    phi = phi
    D = 0.5
    M = 1.0
    c = -0.001
    equielec_strength = -0.6 
    tau = -0.3
    lamda = 1.5
    a = 1.5
    mu = 2.0
    f = 0.5
    eps1 = 6.0
    eps2 = 2.5      
  []
 [./local_energy]
    # Defines the function for the local free energy density as given in the
    # problem, then converts units and adds scaling factor.
    type = DerivativeParsedMaterial
    f_name = f_local
    args = phi
    constant_names = 'tau lamda f a mu'
    constant_expressions = '-0.3 1.5 0.5 1.5 2.0'
    function = '(tau+a*(1-2*f)^2)/2*phi^2+mu*(1-2*f)/3*phi^3+lamda/4*phi^4'
    derivative_order = 2
  [../]

[]

[Postprocessors]
  [./step_size]             # Size of the time step
    type = TimestepSize
  [../]
  [./iterations]            # Number of iterations needed to converge timestep
    type = NumNonlinearIterations
  [../]
  [./nodes]                 # Number of nodes in mesh
    type = NumNodes
  [../]
  [./evaluations]           # Cumulative residual calculations for simulation
    type = NumResidualEvaluations
  [../]
  [./active_time]           # Time computer spent on simulation
    type = PerformanceData
    event =  ACTIVE
  [../]
[]

[Preconditioning]
  [./coupled]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  automatic_scaling = true
  l_max_its = 100
  l_tol = 1e-6
  nl_max_its = 100
  nl_abs_tol = 1e-9
  end_time = 604800   # 7 days
  
#  petsc_options_iname = '-pc_type -pc_hypre_type'
 # petsc_options_value = 'hypre boomeramg'
 
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type
                         -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm      31                  preonly
                         ilu          1'
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 10
    cutback_factor = 0.8
    growth_factor = 1.5
    optimal_iterations = 7
  [../]
#  [./Adaptivity]
#    coarsen_fraction = 0.1
#    refine_fraction = 0.7
#    max_h_level = 2
#  [../]

[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  console = true
  csv = true
  [./console]
    type = Console
    max_rows = 10
  [../]
[]

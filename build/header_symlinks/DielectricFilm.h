//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADMaterial.h"

// A helper class from MOOSE that linear interpolates x,y data
//#include "LinearInterpolation.h"

/**
 * Material-derived objects override the computeQpProperties()
 * function.  They must declare and compute material properties for
 * use by other objects in the calculation such as Kernels and
 * BoundaryConditions.
 */
class DielectricFilm : public ADMaterial
{
public:
  static InputParameters validParams();

  DielectricFilm(const InputParameters & parameters);

protected:
  /**
   * Necessary override.  This is where the values of the properties
   * are computed.
   */
  virtual void computeQpProperties() override;

  /**
   * Helper function for reading CSV data for use in an interpolator object.
   */
 // bool initInputData(const std::string & param_name, ADLinearInterpolation & interp);

  /// The radius of the spheres in the column
  const Function & _input_D;
  const Function & _input_M;
  const Function & _input_c;
  const Function & _input_equielec_strength;
  const Function & _input_tau;
  const Function & _input_a;
  const Function & _input_lamda;
  const Function & _input_mu;
  const Function & _input_f;
  const Function & _input_eps1;
  const Function & _input_eps2;

  /// Volume fraction- local
  const ADVariableValue & _phi;

  MaterialProperty<Real> & _D;
  MaterialProperty<Real> & _M;
  MaterialProperty<Real> & _c;
  MaterialProperty<Real> & _equielec_strength;
   	
  MaterialProperty<Real> & _tau;
  MaterialProperty<Real> & _a;
  MaterialProperty<Real> & _lamda;
  MaterialProperty<Real> & _mu;
  MaterialProperty<Real> & _f;
  MaterialProperty<Real> & _eps1;
  MaterialProperty<Real> & _eps2;
  
  /// Local energy
  ADMaterialProperty<Real> & _f_loc;

  /// Local dielectric
  ADMaterialProperty<Real> & _permeability;
// The viscosity of the fluid (mu)
  ADMaterialProperty<Real> & _viscosity; //This will be placed to 1 in this code
  
  // Pseudo charge density of the fluid
  ADMaterialProperty<Real> & _chargedensity; //This will be placed equal to "phi" in this code

};

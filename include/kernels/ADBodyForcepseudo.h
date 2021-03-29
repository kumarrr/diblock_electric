//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADKernelValue.h"

// Forward Declaration
class Function;

/**
 * This kernel implements a generic functional
 * body force term:
 * $ - c \cdof f \cdot \phi_i $
 *
 * The coefficient DEFAULT IS 1 and VARIABLE f default
 * equal to 0.0.
 */
class ADBodyForcepseudo : public ADKernelValue
{
public:
  static InputParameters validParams();

  ADBodyForcepseudo(const InputParameters & parameters);

protected:
  virtual ADReal precomputeQpResidual() override;

  /// Scale factor
  const Real & _scale;

  /// Charge density term
const ADMaterialProperty<Real> & _chargedensity;

  /// Optional Postprocessor value
  const PostprocessorValue & _postprocessor;
};

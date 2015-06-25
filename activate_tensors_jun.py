#!/usr/bin/env python

import vtk
import sys

pdr = vtk.vtkPolyDataReader()
pdr.SetFileName(sys.argv[1])
pdr.Update()

out = pdr.GetOutput()
pd = out.GetPointData()

#if pd is not None and pd.GetArray('tensor1') is not None:
#	pd.SetTensors(pd.GetArray('tensor1'))

if pd is not None and pd.GetArray('tensor2') is not None:
	pd.SetTensors(pd.GetArray('tensor2'))

## ref http://www.vtk.org/doc/nightly/html/classvtkFieldData.html
##     vtkDataArray* vtkFieldData::GetArray (const char* arrayName) 
## ref http://www.vtk.org/doc/nightly/html/classvtkDataSetAttributes.html
##     int SetTensors (vtkDataArray *da)
## What is the array befor set to tensors? 

pdw = vtk.vtkPolyDataWriter()
#pdw.SetFileTypeToASCII()
pdw.SetFileTypeToBinary()
pdw.SetFileName(sys.argv[2])
pdw.SetInput(out)
#pdw.SetInputData(out)
pdw.Write()
pdw.Update()

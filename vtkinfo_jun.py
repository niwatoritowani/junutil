#!/usr/bin/env python

import vtk
import sys

# Read vtk
pdr = vtk.vtkPolyDataReader()
pdr.SetFileName(sys.argv[1])
pdr.Update()
polydata = pdr.GetOutput()
pointdata = polydata.GetPointData()

## 
## 

# print array info
numArrays = pointdata.GetNumberOfArrays()
print "Number of PointData arrays: %i " % numArrays
for i in range(numArrays):
    print "Array index: %i| name: %s | type: %s" % (i, pointdata.GetArrayName(i), pointdata.GetArray(i).GetDataType())

## ref http://www.vtk.org/doc/nightly/html/classvtkFieldData.html    for GetNumberOfArrays(), GetArrayName(), GetArray()
## ref http://www.vtk.org/doc/nightly/html/classvtkDataArray.html    for GetArray()
## ref http://www.vtk.org/doc/nightly/html/classvtkPoints.html    for GetDataType()
## ref http://www.vtk.org/doc/release/4.0/html/vtkSetGet_8h-source.html    VTK_FLOAT 10

# print tensor info
print "Tensor name (0): %s" % pdr.GetTensorsNameInFile(0)
print "Tensor name (1): %s" % pdr.GetTensorsNameInFile(1)
print "Tensor name (2): %s" % pdr.GetTensorsNameInFile(2)
## ref http://www.vtk.org/doc/nightly/html/classvtkDataReader.html    for GetTensorsNameInFile()

print "Number of scolars: %i" % pdr.GetNumberOfScalarsInFile()
print "Number of vetors: %i" % pdr.GetNumberOfVectorsInFile()
print "Number of tensors: %i" % pdr.GetNumberOfTensorsInFile()
print "Number of normals: %i" % pdr.GetNumberOfNormalsInFile()
print "Number of t coords: %i" % pdr.GetNumberOfTCoordsInFile()
print "Number of field data: %i" % pdr.GetNumberOfFieldDataInFile()
print "field data name (0): %s" % pdr.GetFieldDataNameInFile(0)
print "field data name (1): %s" % pdr.GetFieldDataNameInFile(1)





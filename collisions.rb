SIDELENGTH=2

# Predicts the collision time of two blocks.
#
# @param trajectoryA [Function] predicts the position and angle of block A
#   based on the time.
# @param trajectoryB [Function] As trajectoryA.
# @param step [Float] Time out to which to predict. Collisions beyond this
#   point will not be detected.
# @param step [Integer] Number of times to bisect step trying to find a
#   collision.
# @return [Float,nil] Either nil, if no collision is detected, or a time for
#   that collision.

#def forcastCollision(trajectoryA,trajectoryB,step=1./60,depth=4):
  
def blockDistance(coordsA,coordsB)
  pointsA=[Math::PI/4,3*Math::PI/4,5*Math::PI/4,7*Math::PI/4].map do |offset|
    coordsA[:position]+SIDELENGTH/Math.sqrt(2)*
      Vector[Math.cos(offset+coordsA[:angle]),Math.sin(offset+coordsA[:angle])]
  end
  pointsB=[Math::PI/4,3*Math::PI/4,5*Math::PI/4,7*Math::PI/4].map do |offset|
    coordsB[:position]+SIDELENGTH/Math.sqrt(2)*
      Vector[Math.cos(offset+coordsB[:angle]),Math.sin(offset+coordsB[:angle])]
  end
  #First we check for an intersect:
  edgesA=pointsA.zip(pointsA[1..3]<<pointsA[0])
  edgesB=pointsB.zip(pointsB[1..3]<<pointsB[0])
  if edgesA.product(edgesB).any?{|edgeA,edgeB| lineIntersect?(edgeA,edgeB)}
    return 0
  end
  pairs=pointsA.product(pointsB)
  ((a1,b1),(a2,b2))=pairs.sort_by{|(a,b)| (a-b).r}[0..1]
  if a1==a2 or b1==b2
    #We should have 3 unique points.
    #Two of them share an edge and are therefore SIDELENGTH apart.
    #The paralellMath::PIped formed from these two difference vectors has
    #area SIDELENGTH*distance.
    Matrix.columns([a1-b1,a2-b2]).det.abs/SIDELENGTH
  else
    (a1-b1).r
  end
end  
def lineIntersect?((a1,b1),(a2,b2))
=begin
  puts a1
  puts b1
  puts a2
  puts b2
  puts (Matrix.columns([a1-b1,b2-a2]).inv*(a1-a2))
=end
  begin
    (Matrix.columns([a1-b1,b2-a2]).inv*(a1-a2)).to_a.all?{|x| x.between?(0,1)}
  rescue ExceptionForMatrix::ErrNotRegular
    return false
  end
end
def width(points)
  #points must be ordered such that it forms a convex polygon.
  edges=points.zip(points[1..-1]<<points[0])
  maxDists=edges.map do |(e1,e2)|
    edgeVector=e2-e1
    points.map{|point|
      Matrix.columns([edgeVector,point-e1]).det.abs/edgeVector.r}.max
  end
  maxDists.min
end 
  
  
  

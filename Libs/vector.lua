

Vector = {
        -- ===========================
        -- Sets the metatable of the "point" table to
        -- the Vector table. Kind of like dynamic inheritance.
        -- ===========================
        New = function(self, arg_x, arg_z)
               local point
               if arg_z == nil then
			    point = arg_x
			   else
                point = {x=arg_x, z=arg_z}
              end
                setmetatable(point, {__index = self, 
                                                                __add = self.Add, 
                                                                __sub = self.Sub,
                                                                __eq = self.Equals,
                                                                __unm = self.Negative,
                                                                __mul = self.Mult,
                                                                __div = self.Div,
                                                                __lt = self.Lt,
                                                                __le = self.Le,
                                                                __tostring = self.ToString})
                return point
        end,

        
        -- ===========================
        -- Overload the "+" operator
        -- ===========================
        Add = function(self, other) 
                return Vector:New(self.x + other.x, self.z + other.z) 
        end,
        
        -- ===========================
        -- Overload the "-" operator
        -- ===========================
        Sub = function(self, other)
                return Vector:New(self.x - other.x, self.z - other.z)
        end,
        
        -- ===========================
        -- Check if the other point is the same as self.
        -- ===========================
        Equals = function(self, other)
                return self.x == other.x and self.z == other.z
        end,

        -- ===========================
        -- [Static] Check to see if x and y are close, as defined by eps (if it is passed)
        -- ===========================
        CloseTo = function(x, y, eps)
                if not eps then 
                        eps = 1e-9 
                end
                return math.abs(x - y) <= eps
        end,
        
        -- ===========================
        -- [Static] Get the intersection point of lines L1=(base1,v1) L2=(base2,v2)
        -- ===========================
        InfLineIntersection = function(base1, v1, base2, v2)
                if Vector.CloseTo(v1.x, 0.0) and Vector.CloseTo(v2.z, 0.0) then
                        return Vector:New({x = base1.x, z = base2.z})
                end
                if Vector.CloseTo(v1.z, 0.0) and Vector.CloseTo(v2.x, 0.0) then
                        return Vector:New({x = base2.x, z = base1.z})
                end
                
                local m1 = (not Vector.CloseTo(v1.x, 0.0)) and v1.z / v1.x or 0.0
                local m2 = (not Vector.CloseTo(v2.x, 0.0)) and v2.z / v2.x or 0.0
                
                if Vector.CloseTo(m1, m2) then
                        return nil
                end
                
                local c1 = base1.z - m1 * base1.x
                local c2 = base2.z - m2 * base2.x
                
                local ix = (c2 - c1) / (m1 - m2)
                local iy = m1 * ix + c1
                if Vector.CloseTo(v1.x, 0.0) then
                        return Vector:New({x = base1.x, z = base1.x * m2 + c2})
                end
                if Vector.CloseTo(v2.x, 0.0) then
                        return Vector:New({x = base2.x, z = base2.x * m1 + c1})
                end
                return Vector:New({x = ix, z = iy})
        end,
        
        -- ===========================
        -- Returns a positive number if self > other, 0 if self == other, and
        -- a negative number if self < other.
        -- ===========================
        CompareTo = function(self, other)
                local ret = self.x - other.x
                if ret == 0 then
                        ret = self.z - other.z
                end
                return ret
        end,
        
        -- ===========================
        -- Scale the current point to get a new point.
        -- ===========================
        Scale = function(self, factor)
                return Vector:New({x = self.x * factor, z = self.z * factor})
        end,

        -- ===========================
        -- Get the string representation of the point.
        -- ===========================  
        ToString = function(self)
                return "(" .. tostring(self.x) .. ", " .. tostring(self.z) .. ")"
        end,
        
        -- ===========================
        -- Computes the angle formed by p1 - self - p2
        -- ===========================
        AngleBetween = function(self, p1, p2)
                local vect_p1 = p1 - self
                local vect_p2 = p2 - self
                local theta = vect_p1:Polar() - vect_p2:Polar()
                if theta < 0.0 then
                        theta = theta + 360.0
                end
                if theta > 180.0 then
                        theta = 360.0 - theta
                end
                return theta
        end,
        
        -- ===========================
        -- Compute the polar angle to this point
        -- ===========================
        Polar = function(self)
                theta = 0.0
                if Vector.CloseTo(self.x, 0) then
                        if self.z > 0 then
                                theta = 90.0
                        elseif self.z < 0 then
                                theta = 270.0
                        end
                else
                        theta = math.deg(math.atan(self.z/self.x))
                        if self.x < 0.0 then
                                theta = theta + 180.0
                        end
                        if theta < 0.0 then
                                theta = theta + 360.0
                        end
                end
                return theta
        end,
        
        -- ===========================
        -- Gets the left normal according to self's position.
        -- ===========================
        NormalLeft = function(self)
                return Vector:New({x = self.z, z = -self.x})
        end,
        
        -- ===========================
        -- Get the center between self and the other point.
        -- ===========================
        Center = function(self, otherVector)
                return Vector:New({x = (self.x + otherVector.x) / 2, z = (self.z + otherVector.z) / 2})
        end,
        
        -- ===========================
        -- Get the distance between myself and the other point.
        -- ===========================
        Distance = function(self, otherVector)
                local dx = self.x - otherVector.x
                local dy = self.z - otherVector.z
                return math.sqrt(dx * dx + dy * dy)
        end,
        
        -- ===========================
        -- Tests if a point is left|on|right of an infinite line
        -- return >0 for p2 left of line through p0 and p1.
        -- return =0 for p2 on the line.
        -- return <0 for p2 right of the line.
        -- ===========================
        Direction = function(p0, p1, p2)
                return (p0.x-p1.x)*(p2.z-p1.z) - (p2.x-p1.x)*(p0.z-p1.z)
        end,

        -- ===========================
        -- h0nda added staff
        -- ===========================
        Cross = function(self,other)
            return self.x * other.z - self.z * other.x
        end,

        Negative = function(self)
            return Vector:New({x=-1*self.x,z=-1*self.z})
        end,
        Mult = function (a, b)
          if type(a) == "number" then
            return Vector.new({x=b.x * a, y=b.z * a})
            elseif type(b) == "number" then
              return Vector:New({x=a.x * b, z=a.z * b})
            else
              return Vector:New({x=a.x * b.x, z=a.z * b.z})
            end
          end,
        Div = function(a,b)
          if type(a) == "number" then
            return Vector.new({x=b.x / a, y=b.z / a})
          elseif type(b) == "number" then
            return Vector:New({x=a.x / b, z=a.z / b})
          else
            return Vector:New({x= a.x / b.x, z=a.z / b.z})
          end
        end,
        Lt = function(a,b)
         return a.x < b.x or (a.x == b.x and a.z < b.z)
        end,
        Le = function(a,b)
          return a.x <= b.x and a.z <= b.z
        end,
        Clone = function(self)
          return Vector:New({x=self.x, z=self.z})
        end,
        Unpack = function(self)
          return self.x, self.z
        end,
        Length = function ( self )
          return math.sqrt(self.x * self.x + self.z * self.z)
        end,
        LengthSQ = function ( self)
           return self.x * self.x + self.z * self.z
        end,

        Normalize = function (self )
          local len = self:Length()
          self.x = self.x / len
          self.z = self.z / len
          return self
        end,

        Normalized = function (self )
          return self / self:Length()
        end,

        Rotate = function(phi)
          local c = math.cos(phi)
          local s = math.sin(phi)
          self.x = c * self.x - s * self.z
          self.z = s * self.x + c * self.z
          return self
        end,

        Rotated = function(phi)
           return self:clone():rotate(phi)
        end,

        Perpendicular = function()
          return Vector:New({x=-self.z, z=self.x})
        end,

        ProjectOn = function(other)
          return (self * other) * other / other:lenSq()
        end,

}



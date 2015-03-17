class Projectile

  attr_reader :u, :teta, :angle

  def initialize(u, angle)
    @angle = angle
    @u     = u
    @teta  = to_rad(angle)
    @g     = 9.8;
  end

  def horizontal_range
    (@u * @u * Math.sin(2 * @teta) / @g).round(4)
  end

  def maximum_height
    (@u * @u * Math.sin(@teta) * Math.sin(@teta) / (2.0 * @g)).round(4)
  end

  def time_period
    (2 * @u * Math.sin(@teta) / @g).round(4)
  end

  def height(t)
    ((@u * Math.sin(@teta) * t) - (@g * t * t / 2.0)).round(4)
  end

  def range(t)
    (@u * Math.cos(@teta) * t).round(4)
  end

  private

  def to_rad(angle)
    angle * Math::PI / 180.0
  end
end

p = Projectile.new(10, 45)

puts "*"*100
puts "Initial conditions"
puts "Initial Velocity #{p.u} m/s"
puts "Angle of flight #{p.angle} degree"
puts "*"*100
puts  "Maximum Height: #{p.maximum_height} m"
puts  "Horizontal Range: #{p.horizontal_range} m"
puts  "Time Period: #{p.time_period} s"
puts "*"*100


t = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4]

t.each do |t|
  puts "time #{t} s: range #{p.range(t)} m height #{p.height(t)}"
end

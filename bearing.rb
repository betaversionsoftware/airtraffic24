def bearing(lat1, lng1, lat2, lng2)
  x = Math::sin(lng2-lng1)*Math::cos(lat2) 
  y = Math::cos(lat1)*Math::sin(lat2) - Math::sin(lat1)*Math::cos(lat2)*Math::cos(lng2-lng1)
  bearing = Math::atan2(x, y)
  bearing_degree = (bearing * 180) / Math::PI
  ((bearing_degree + 360) % 360).round
end


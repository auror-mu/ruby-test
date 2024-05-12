require 'json'

file = File.open('data.json')
json = file.read
parsed = JSON.parse(json)

# how much each shift worker is supposed to be paid
# return each worker pay and stock it in output.json

# workers_pay = {user_id => total pay}
# worker_id = parsed['shifts'].each do { |shift| shift.user_id }
# pay = n_shifts/worker * price_per_shift

shifts_per_worker = Hash.new(0)

parsed['shifts'].each do |shift|
  shifts_per_worker[shift['user_id']] += 1 #{user_id =>n_shifts}
end

workers_pay = {}

parsed['workers'].each do |worker|
  worker_id = worker['id']
  price_per_shift = worker['price_per_shift']

  total_shifts = shifts_per_worker[worker_id]
  total_pay = total_shifts * price_per_shift

  workers_pay[worker_id] = total_pay
end

puts workers_pay

File.open('output.json', 'w') do |file|
file.write(JSON.pretty_generate(workers_pay))
end

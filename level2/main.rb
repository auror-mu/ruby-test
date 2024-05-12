require 'json'

file = File.open('data.json')
json = file.read
parsed = JSON.parse(json)

shifts_per_worker = Hash.new(0)

parsed['shifts'].each do |shift|
  shifts_per_worker[shift['user_id']] += 1
end

intern_pay = 126
medic_pay = 270

workers_pay = {}

parsed['workers'].each do |worker|
  worker_id = worker['id']
  price_per_shift = worker['status'] == 'interne' ? intern_pay : medic_pay

  total_shifts = shifts_per_worker[worker_id]
  total_pay = total_shifts * price_per_shift

  workers_pay[worker_id] = total_pay
end

File.open('output.json', 'w') do |file|
file.write(JSON.pretty_generate(workers_pay))
end

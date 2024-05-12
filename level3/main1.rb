# je passe aux OOP, le code est plus lisible

require 'json'
require 'date'

require_relative 'worker'
require_relative 'shift'
require_relative 'payment'

file = File.open('data.json')
json = file.read
parsed = JSON.parse(json)

workers = parsed['workers'].map { |worker| Worker.new(worker['id'], worker['status']) }

shifts = parsed['shifts'].reject { |shift| shift['user_id'].nil? || shift['user_id'] == 'null' }
.map { |shift| Shift.new(shift['user_id'], shift['start_date']) }

def calculate_shifts_per_worker(shifts)
  shifts_per_worker = Hash.new(0)

  shifts.each do |shift|
    if shift.is_weekend?
      shifts_per_worker[shift.user_id] += 2
    else
      shifts_per_worker[shift.user_id] += 1
    end
  end
  shifts_per_worker
end

def calculate_workers_pay(workers, shifts_per_worker)
  workers_pay = {}
  workers.each do |worker|
    total_shifts = shifts_per_worker[worker.id]
    price_per_shift = worker.status == 'interne' ? Payment::INTERN_PAY : Payment::MEDIC_PAY
    total_pay = total_shifts * price_per_shift

    workers_pay[worker.id] = total_pay
  end
  workers_pay
end

shifts_per_worker = calculate_shifts_per_worker(shifts)
workers_pay = calculate_workers_pay(workers, shifts_per_worker)
puts shifts_per_worker
puts workers_pay

File.open('output.json', 'w') do |file|
  file.write(JSON.pretty_generate(workers_pay))
  end

SAMPLE_CLK_FREQ = 48000
ACCUMULATOR_BITS = 26
ACCUMULATOR_SIZE = 2**ACCUMULATOR_BITS

def calculate_phase_increment(n):
    value = int(ACCUMULATOR_SIZE / (n * SAMPLE_CLK_FREQ))
    return str(value)

attack_seconds = [ 0.002, 0.008, 0.016, 0.024, 0.038, 0.056, 0.068, 0.080, 0.100, 0.250, 0.500, 0.800, 1.000, 3.000, 5.000, 8.000 ]

decay_seconds = [ 0.006, 0.024, 0.048, 0.072, 0.114, 0.168, 0.204, 0.240, 0.300, 0.750, 1.500, 2.400, 3.000, 9.000, 15.00, 24.00 ]

with open("attack_increments.txt", "w") as attack_data:
    increments = map(calculate_phase_increment, attack_seconds)
    attack_data.write("\n".join(increments))

with open("decay_increments.txt", "w") as decay_data:
    increments = map(calculate_phase_increment, decay_seconds)
    decay_data.write("\n".join(increments))

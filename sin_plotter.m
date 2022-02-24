
output_bit_size = 8;
sampling_freq = 250;
num_seconds = 5;

sample_numbers = [0:(sampling_freq-1)*num_seconds];


lo_freq = 18;
#hi_freq = 30;
hi_freq = 50;

wave_lo = sin(2*pi*lo_freq/sampling_freq*sample_numbers);
wave_hi = sin(2*pi*hi_freq/sampling_freq*sample_numbers);

input_vector = wave_hi + wave_lo;



normalized_input_vector = rescale(input_vector, -127, 128);

# plot(normalized_input_vector)

quantized_normalized_input_vector = cast(normalized_input_vector, 'int8');
 plot(quantized_normalized_input_vector);


fileID = fopen("input_test2.dat", "w");

for row = 1:length(quantized_normalized_input_vector)
  fprintf(fileID, "%d\n", quantized_normalized_input_vector(row));
end

fclose(fileID);
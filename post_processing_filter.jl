using CSV
using DataFrames
f = CSV.File("output_test1.dat")
df = DataFrame(f)
data = df[!, 1]
arr = []
for i in data
	if i != "xxxxxxxx"
		push!(arr,i)
	end
end

fin = []
for i in arr
	push!(fin, reinterpret(Int8, parse(UInt8,i;base = 2)))
end

scatter(arr)
scatter(fin)

fin1 = []
for i in 2:length(fin)-1
	if fin[i-1] != fin[i]
		push!(fin1, fin[i-1])
	end
end

push!(fin1, 38)
plot(fin1)

fin2 = 1/69 .* fin1
plot(fin2)

plot(abs.(fft(fin2)))

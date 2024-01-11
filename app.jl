using GenieFramework, DataFrames, CSV, PlotlyBase
@genietools

const FILE_PATH = joinpath("public", "uploads")
mkpath(FILE_PATH)

@app begin
    @out title = "CSV Analysis"
    @out upfiles = readdir(FILE_PATH)
    @in selected_file = "iris.csv"
    @in selected_column = "petal.length"
    @out columns = ["petal.length", "petal.width", "sepal.length", "sepal.width", "variety"]
    @out trace = [histogram()]
    @out layout = PlotlyBase.Layout(yaxis_title_text="Count",xaxis_title_text="Value")
    @private data = DataFrame()

    @onchange fileuploads begin
        @show fileuploads
        if ! isempty(fileuploads)
            @info "File was uploaded: " fileuploads
            notify(__model__,"File was uploaded: $(fileuploads)")
            filename = fileuploads["name"]

            try
                isdir(FILE_PATH) || mkpath(FILE_PATH)
                mv(fileuploads["path"], joinpath(FILE_PATH, filename), force=true)
            catch e
                @error "Error processing file: $e"
                notify(__model__,"Error processing file: $(fileuploads["name"])")
            end

            fileuploads = Dict{AbstractString,AbstractString}()
        end
        upfiles = readdir(FILE_PATH)
    end

    @event rejected begin
        @info "rejected"
        notify(__model__, "Please upload a valid file")
    end

    @onchange isready,selected_file begin
        data = CSV.read(joinpath(FILE_PATH, selected_file), DataFrame)
        columns = names(data)
    end

    @onchange isready, selected_column begin
        trace = [histogram(x=data[!, selected_column])]
    end

end


@page("/", "ui.jl")

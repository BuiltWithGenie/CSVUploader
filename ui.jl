
 heading("{{title}}")
 row([
      cell(class="col-md-12", [
                               uploader( multiple = true,
                                        accept = ".csv",
                                        maxfilesize = 1024*1024*1,
                                        maxfiles = 3,
                                        autoupload = true,
                                        hideuploadbtn = true,
                                        label = "Upload datasets",
                                        nothumbnails = true,
                                        style="max-width: 95%; width: 95%; margin: 0 auto;",

                                        @on("rejected", :rejected),
                                        @on("uploaded", :uploaded)
                                       )

                              ])
     ])
row([
     cell(
          class="st-module",
          [
           h6("File")
           Stipple.select(:selected_file; options=:upfiles)
          ]
         )
     cell(
          class="st-module",
          [
           h6("Column")
           Stipple.select(:selected_column; options=:columns)
          ]
         )
    ])
row([
     cell(
          class="st-module",
          [
           h5("Histogram")
           plot(:trace, layout=:layout)
          ]
         )
    ])

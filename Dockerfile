FROM rocker/shiny:3.5.1
MAINTAINER Marine Institute
# install ssl
# and gdal
RUN sudo apt-get update && apt-get install -y libssl-dev libudunits2-0 libudunits2-dev libproj-dev libgdal-dev && apt-get clean && rm -rf /var/lib/apt/lists/ && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
# install additional packages
#RUN Rscript -e "install.packages(c('knitr','rgdal','pander','kableExtra','leaflet','leaflet.extras','mapedit','readr','ncdf4','ggplot2','rasterVis','sf','raster','sp','knitr','htmltools','plyr','dplyr'), repos='https://cran.rstudio.com/')"
## fixing running as non root
RUN sudo chown -R shiny:shiny /var/lib/shiny-server/
RUN Rscript -e "install.packages(c('shiny','shinydashboardPlus','shinycssloaders','shinythemes','shinyWidgets'), repos='https://cran.rstudio.com/')" && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN Rscript -e "install.packages(c('knitr','rgdal','pander','kableExtra','leaflet','leaflet.extras','mapedit','readr','ncdf4','ggplot2','rasterVis','sf','raster','sp','knitr','htmltools','plyr','dplyr'), repos='https://cran.rstudio.com/')"


COPY www /srv/shiny-server/ecosystem/www
COPY Data /srv/shiny-server/ecosystem/Data
COPY functions /srv/shiny-server/ecosystem/functions
COPY results /src/shiny-server/ecosystem/results
COPY Data-Sources.html /srv/shiny-server/ecosystem/
COPY README.md /srv/shiny-server/ecosystem/
COPY app.R /srv/shiny-server/ecosystem/
COPY ShinyandRMD.Rproj /srv/shiny-server/ecosystem/
COPY report.Rmd /srv/shiny-server/ecosystem/


EXPOSE 3838
CMD ["/usr/bin/shiny-server.sh"]

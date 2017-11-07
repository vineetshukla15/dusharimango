#scp static/css/*.css dashqa.alphonso.tv:~/dashboards/server/static/css/.
#scp static/js/*.js dashqa.alphonso.tv:~/dashboards/server/static/js/.
#scp static/img/*.png dashqa.alphonso.tv:~/dashboards/server/static/img/.

#scp views/pages/*.ejs dashqa.alphonso.tv:~/dashboards/server/views/pages/.
#scp views/partials/*.ejs dashqa.alphonso.tv:~/dashboards/server/views/partials/.

#scp server.js dashqa.alphonso.tv:~/dashboards/server/.
#scp app-config/*.js dashqa.alphonso.tv:~/dashboards/server/app-config/.
#scp util/*.js dashqa.alphonso.tv:~/dashboards/server/util/.

rsync -ar static/css dashqa.alphonso.tv:~/dashboards/server/static/
rsync -ar static/js dashqa.alphonso.tv:~/dashboards/server/static/
rsync -ar static/img dashqa.alphonso.tv:~/dashboards/server/static/

rsync -a server.js dashqa.alphonso.tv:~/dashboards/server/.
rsync -ar app-config dashqa.alphonso.tv:~/dashboards/server/
rsync -ar util dashqa.alphonso.tv:~/dashboards/server/
rsync -ar views dashqa.alphonso.tv:~/dashboards/server/
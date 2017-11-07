#rsync -ar static amit@insights.alphonso.tv:~/dashboards/server/
rsync -ar static/css insights.alphonso.tv:~/dashboards/server/static/
rsync -ar static/js insights.alphonso.tv:~/dashboards/server/static/
rsync -ar static/img insights.alphonso.tv:~/dashboards/server/static/

rsync -a server.js insights.alphonso.tv:~/dashboards/server/.
rsync -ar app-config insights.alphonso.tv:~/dashboards/server/
rsync -ar util insights.alphonso.tv:~/dashboards/server/
rsync -ar views insights.alphonso.tv:~/dashboards/server/
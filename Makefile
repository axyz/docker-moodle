TIMESTAMP = $(shell date +"%Y-%m-%d_%H:%M")
BACKUP_DIR = backup/$(TIMESTAMP)

backup: prepare-backup backup-db backup-moodle backup-moodledata

prepare-backup:
	@mkdir -p $(BACKUP_DIR)

backup-db:
	@docker exec moodle_db_1 mysqldump -h localhost -u root --password=admin -C -Q -e --create-options moodle > $(BACKUP_DIR)/moodle-database-$(TIMESTAMP).sql

backup-moodle:
	@docker exec moodle_moodle_1 tar cvf - /var/www/htdocs | gzip > $(BACKUP_DIR)/moodle-$(TIMESTAMP).tar.gz

backup-moodledata:
	@docker exec moodle_moodle_1 tar cvf - /var/www/moodledata | gzip > $(BACKUP_DIR)/moodledata-$(TIMESTAMP).tar.gz

.PHONY: backup

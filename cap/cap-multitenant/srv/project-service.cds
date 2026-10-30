using { multitenant.projects as db } from '../db/schema';

@path: '/projects'
@requires: 'authenticated-user'
service ProjectService {

    @odata.draft.enabled
    entity Projects as projection on db.Projects actions {
        action completeProject() returns Projects;
    };

    entity Tasks as projection on db.Tasks;
    entity TeamMembers as projection on db.TeamMembers;
}
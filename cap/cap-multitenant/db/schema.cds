
namespace multitenant.projects;

using { cuid, managed } from '@sap/cds/common';

entity Projects : cuid, managed {
    name        : String(150) not null;
    description : String(500);
    status      : String(20) default 'PLANNED';
    startDate   : Date;
    endDate     : Date;

    tasks       : Composition of many Tasks
                    on tasks.project = $self;

    members     : Composition of many TeamMembers
                    on members.project = $self;
}

entity Tasks : cuid, managed {
    project     : Association to Projects;
    title       : String(150) not null;
    description : String(500);
    priority    : String(20) default 'MEDIUM';
    status      : String(20) default 'OPEN';
    dueDate     : Date;
}

entity TeamMembers : cuid, managed {
    project     : Association to Projects;
    firstName   : String(100) not null;
    lastName    : String(100) not null;
    email       : String(255);
    role        : String(50);
}

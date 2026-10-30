
using ProjectService as service from './project-service';

annotate service.Projects with @restrict: [
    { grant: 'READ', to: 'Viewer' },
    { grant: '*', to: 'Manager' }
];

annotate service.Tasks with @restrict: [
    { grant: 'READ', to: 'Viewer' },
    { grant: '*', to: 'Manager' }
];

annotate service.TeamMembers with @restrict: [
    { grant: 'READ', to: 'Viewer' },
    { grant: '*', to: 'Manager' }
];

annotate service.Projects with actions {
    completeProject @requires: 'Manager';
};

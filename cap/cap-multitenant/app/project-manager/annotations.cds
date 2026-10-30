using ProjectService as service from '../../srv/project-service';

// ==========================================
// PROJECTS
// ==========================================

annotate service.Projects with {
    name        @Common.Label: 'Project Name';
    status      @Common.Label: 'Project Status';
    startDate   @Common.Label: 'Start Date';
    endDate     @Common.Label: 'Expected End Date';
    description @Common.Label: 'Project Description';
};

annotate service.Projects with @(
    Common.Label          : 'Projects',

    UI.HeaderInfo         : {
        TypeName      : 'Project',
        TypeNamePlural: 'Projects',
        Title         : {
            $Type: 'UI.DataField',
            Value: name
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: status
        }
    },

    UI.SelectionFields    : [
        name,
        status,
        startDate
    ],

    UI.LineItem           : [
        {
            $Type: 'UI.DataField',
            Label: 'Project Name',
            Value: name
        },
        {
            $Type: 'UI.DataField',
            Label: 'Project Status',
            Value: status
        },
        {
            $Type: 'UI.DataField',
            Label: 'Start Date',
            Value: startDate
        },
        {
            $Type             : 'UI.DataFieldForAction',
            Action            : 'ProjectService.completeProject',
            Label             : 'Complete Project',
            InvocationGrouping: #Isolated
        },
        {
            $Type: 'UI.DataField',
            Label: 'Expected End Date',
            Value: endDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'Created By',
            Value: createdBy
        },
        {
            $Type: 'UI.DataField',
            Label: 'Created On',
            Value: createdAt
        }
    ],

    UI.Facets             : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneralInformation',
            Label : 'Project Information',
            Target: '@UI.FieldGroup#General'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Tasks',
            Label : 'Project Tasks',
            Target: 'tasks/@UI.LineItem'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Members',
            Label : 'Project Team Members',
            Target: 'members/@UI.LineItem'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'AuditInformation',
            Label : 'Audit Information',
            Target: '@UI.FieldGroup#Audit'
        }
    ],

    UI.FieldGroup #General: {
        $Type: 'UI.FieldGroupType',
        Label: 'Project Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Project Name',
                Value: name
            },
            {
                $Type: 'UI.DataField',
                Label: 'Project Description',
                Value: description
            },
            {
                $Type: 'UI.DataField',
                Label: 'Project Status',
                Value: status
            },
            {
                $Type: 'UI.DataField',
                Label: 'Start Date',
                Value: startDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'Expected End Date',
                Value: endDate
            },
        ]
    },

    UI.FieldGroup #Audit  : {
        $Type: 'UI.FieldGroupType',
        Label: 'Audit Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Created On',
                Value: createdAt
            },
            {
                $Type: 'UI.DataField',
                Label: 'Created By',
                Value: createdBy
            },
            {
                $Type: 'UI.DataField',
                Label: 'Last Changed On',
                Value: modifiedAt
            },
            {
                $Type: 'UI.DataField',
                Label: 'Last Changed By',
                Value: modifiedBy
            }
        ]
    }
);

// ==========================================
// PROJECT TASKS
// ==========================================

annotate service.Tasks with @(
    Common.Label                  : 'Project Tasks',

    UI.LineItem                   : [
        {
            $Type: 'UI.DataField',
            Label: 'Task Title',
            Value: title
        },
        {
            $Type: 'UI.DataField',
            Label: 'Task Description',
            Value: description
        },
        {
            $Type: 'UI.DataField',
            Label: 'Priority',
            Value: priority
        },
        {
            $Type: 'UI.DataField',
            Label: 'Task Status',
            Value: status
        },
        {
            $Type: 'UI.DataField',
            Label: 'Due Date',
            Value: dueDate
        }
    ],

    UI.FieldGroup #TaskInformation: {
        $Type: 'UI.FieldGroupType',
        Label: 'Task Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Task Title',
                Value: title
            },
            {
                $Type: 'UI.DataField',
                Label: 'Task Description',
                Value: description
            },
            {
                $Type: 'UI.DataField',
                Label: 'Priority',
                Value: priority
            },
            {
                $Type: 'UI.DataField',
                Label: 'Task Status',
                Value: status
            },
            {
                $Type: 'UI.DataField',
                Label: 'Due Date',
                Value: dueDate
            }
        ]
    },

    UI.Facets                     : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'TaskInformation',
        Label : 'Task Information',
        Target: '@UI.FieldGroup#TaskInformation'
    }]
);

// ==========================================
// PROJECT TEAM MEMBERS
// ==========================================

annotate service.TeamMembers with @(
    Common.Label                    : 'Project Team Members',

    UI.LineItem                     : [
        {
            $Type: 'UI.DataField',
            Label: 'First Name',
            Value: firstName
        },
        {
            $Type: 'UI.DataField',
            Label: 'Last Name',
            Value: lastName
        },
        {
            $Type: 'UI.DataField',
            Label: 'Email Address',
            Value: email
        },
        {
            $Type: 'UI.DataField',
            Label: 'Project Role',
            Value: role
        }
    ],

    UI.FieldGroup #MemberInformation: {
        $Type: 'UI.FieldGroupType',
        Label: 'Member Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'First Name',
                Value: firstName
            },
            {
                $Type: 'UI.DataField',
                Label: 'Last Name',
                Value: lastName
            },
            {
                $Type: 'UI.DataField',
                Label: 'Email Address',
                Value: email
            },
            {
                $Type: 'UI.DataField',
                Label: 'Project Role',
                Value: role
            }
        ]
    }
);

sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"projectmanager/test/integration/pages/ProjectsList.gen",
	"projectmanager/test/integration/pages/ProjectsObjectPage.gen",
	"projectmanager/test/integration/pages/TasksObjectPage.gen"
], function (JourneyRunner, ProjectsListGenerated, ProjectsObjectPageGenerated, TasksObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('projectmanager') + '/test/flp.html#app-preview',
        pages: {
			onTheProjectsListGenerated: ProjectsListGenerated,
			onTheProjectsObjectPageGenerated: ProjectsObjectPageGenerated,
			onTheTasksObjectPageGenerated: TasksObjectPageGenerated
        },
        async: true
    });

    return runner;
});


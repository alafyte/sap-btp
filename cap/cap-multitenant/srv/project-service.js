const cds = require('@sap/cds');

module.exports = class ProjectService extends cds.ApplicationService {
    async init() {

        this.on('completeProject', 'Projects', async (req) => {
            const { ID } = req.params[0];

            const tx = cds.tx(req);

            const project = await tx.run(
                SELECT.one.from('multitenant.projects.Projects')
                    .where({ ID })
            );

            if (!project) {
                return req.reject(404, 'Project not found');
            }

            if (project.status === 'COMPLETED') {
                return req.reject(400, 'Project is already completed');
            }

            await tx.run(
                UPDATE('multitenant.projects.Projects')
                    .set({ status: 'COMPLETED' })
                    .where({ ID })
            );

            return tx.run(
                SELECT.one.from('ProjectService.Projects')
                    .where({ ID })
            );
        });

        await super.init();
    }
};
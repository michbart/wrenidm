/**
 * The contents of this file are subject to the terms of the Common Development and
 * Distribution License (the License). You may not use this file except in compliance with the
 * License.
 *
 * You can obtain a copy of the License at legal/CDDLv1.0.txt. See the License for the
 * specific language governing permission and limitations under the License.
 *
 * When distributing Covered Software, include this CDDL Header Notice in each file and include
 * the License file at legal/CDDLv1.0.txt. If applicable, add the following below the CDDL
 * Header, with the fields enclosed by brackets [] replaced by your own identifying
 * information: "Portions copyright [year] [name of copyright owner]".
 *
 * Copyright 2014-2017 ForgeRock AS.
 */

define([
    "config/routes/CommonRoutesConfig"
], function(commonRoutes) {

    var obj = {
        "dashboardView" : {
            view: "org/forgerock/openidm/ui/admin/dashboard/Dashboard",
            role: "ui-admin",
            url: /^dashboard\/(.*)$/,
            pattern: "dashboard/?"
        },
        "newDashboardView" : {
            view: "org/forgerock/openidm/ui/admin/dashboard/NewDashboard",
            role: "ui-admin",
            url: "newDashboard/"
        },
        "userRegistrationView" : {
            view: "org/forgerock/openidm/ui/admin/selfservice/UserRegistrationConfigView",
            role: "ui-admin",
            url: "selfservice/userregistration/"
        },
        "passwordResetView" : {
            view: "org/forgerock/openidm/ui/admin/selfservice/PasswordResetConfigView",
            role: "ui-admin",
            url: "selfservice/passwordreset/"
        },
        "forgotUsernameView" : {
            view: "org/forgerock/openidm/ui/admin/selfservice/ForgotUsernameConfigView",
            role: "ui-admin",
            url: "selfservice/forgotUsername/"
        },
        "connectorListView" : {
            view: "org/forgerock/openidm/ui/admin/connector/ConnectorListView",
            role: "ui-admin",
            url: "connectors/"
        },
        "editConnectorView" : {
            view: "org/forgerock/openidm/ui/admin/connector/EditConnectorView",
            role: "ui-admin",
            defaults : ["", ""],
            url: /^connectors\/edit\/(.+?)\/(.*)$/,
            pattern: "connectors/edit/?/?"
        },
        "addConnectorView" : {
            view: "org/forgerock/openidm/ui/admin/connector/AddConnectorView",
            role: "ui-admin",
            url: "connectors/add/"
        },
        "managedListView" : {
            view: "org/forgerock/openidm/ui/admin/managed/ManagedListView",
            role: "ui-admin",
            url: "managed/"
        },
        "editManagedView" : {
            view: "org/forgerock/openidm/ui/admin/managed/EditManagedView",
            role: "ui-admin",
            url: /^managed\/edit\/(.+)\/$/,
            pattern: "managed/edit/?/"
        },
        "editSchemaPropertyView" : {
            view: "org/forgerock/openidm/ui/admin/managed/schema/SchemaPropertyView",
            role: "ui-admin",
            url: /^managed\/edit\/(.+)\/property\/(.+)$/,
            pattern: "managed/edit/?/property/?"
        },
        "addManagedView" : {
            view: "org/forgerock/openidm/ui/admin/managed/AddManagedView",
            role: "ui-admin",
            url: "managed/add/"
        },
        "authenticationView" : {
            view: "org/forgerock/openidm/ui/admin/authentication/AuthenticationView",
            role: "ui-admin",
            url: "authentication/"
        },
        "settingsView": {
            view: "org/forgerock/openidm/ui/admin/settings/SettingsView",
            role: "ui-admin",
            url: /^settings\/(.*)$/,
            pattern: "settings/?/",
            defaults: ["audit"]
        },
        "addMappingView" : {
            view: "org/forgerock/openidm/ui/admin/mapping/AddMappingView",
            role: "ui-admin",
            url: "mapping/add/"
        },
        "autoAddMappingView" : {
            view: "org/forgerock/openidm/ui/admin/mapping/AddMappingView",
            role: "ui-admin",
            url: /mapping\/add\/(.+?)\/(.+?)$/,
            pattern: "mapping/add/?/?"
        },
        "mappingListView" : {
            view: "org/forgerock/openidm/ui/admin/mapping/MappingListView",
            role: "ui-admin",
            url: "mapping/"
        },
        "propertiesView" : {
            childView: "org/forgerock/openidm/ui/admin/mapping/PropertiesView",
            view: "org/forgerock/openidm/ui/admin/mapping/MappingBaseView",
            role: "ui-admin",
            url: /^properties\/([^\/]+)\/$/,
            pattern: "properties/?/"
        },
        "behaviorsView" : {
            childView: "org/forgerock/openidm/ui/admin/mapping/BehaviorsView",
            view: "org/forgerock/openidm/ui/admin/mapping/MappingBaseView",
            role: "ui-admin",
            url: /^behaviors\/(.+)\/$/,
            pattern: "behaviors/?/"
        },
        "associationView" : {
            childView: "org/forgerock/openidm/ui/admin/mapping/AssociationView",
            view: "org/forgerock/openidm/ui/admin/mapping/MappingBaseView",
            role: "ui-admin",
            url: /^association\/(.+)\/$/,
            pattern: "association/?/"
        },
        "scheduleView" : {
            childView: "org/forgerock/openidm/ui/admin/mapping/ScheduleView",
            view: "org/forgerock/openidm/ui/admin/mapping/MappingBaseView",
            role: "ui-admin",
            url: /^schedule\/(.+)\/$/,
            pattern: "schedule/?/"
        },
        "advancedView" : {
            childView: "org/forgerock/openidm/ui/admin/mapping/AdvancedView",
            view: "org/forgerock/openidm/ui/admin/mapping/MappingBaseView",
            role: "ui-admin",
            url: /^advanced\/(.+)\/$/,
            pattern: "advanced/?/"
        },
        "adminListSystemObjectView" : {
            view: "org/forgerock/openidm/ui/common/resource/ListResourceView",
            role: "ui-admin",
            url: /^resource\/(system)\/(.+)\/(.+)\/list\/$/,
            pattern: "resource/?/?/?/list/"
        },
        "adminEditSystemObjectView" : {
            view: "org/forgerock/openidm/ui/common/resource/EditResourceView",
            role: "ui-admin",
            url: /^resource\/(system)\/(.+)\/(.+)\/edit\/(.+)$/,
            pattern: "resource/?/?/?/edit/?",
            forceUpdate: true
        },
        "adminNewSystemObjectView" : {
            view: "org/forgerock/openidm/ui/common/resource/EditResourceView",
            role: "ui-admin",
            url: /^resource\/(system)\/(.+)\/(.+)\/add\/$/,
            pattern: "resource/?/?/?/add/"
        },
        "adminListManagedObjectView" : {
            view: "org/forgerock/openidm/ui/common/resource/ListResourceView",
            role: "ui-admin",
            url: /^resource\/(managed)\/(.+)\/list\/$/,
            pattern: "resource/?/?/list/"
        },
        "adminEditManagedObjectView" : {
            view: "org/forgerock/openidm/ui/common/resource/EditResourceView",
            role: "ui-admin",
            url: /^resource\/(managed)\/(.+)\/edit\/(.+)$/,
            pattern: "resource/?/?/edit/?"
        },
        "adminNewManagedObjectView" : {
            view: "org/forgerock/openidm/ui/common/resource/EditResourceView",
            role: "ui-admin",
            url: /^resource\/(managed)\/(.+)\/add\/$/,
            pattern: "resource/?/?/add/"
        },
        "adminEditRoleEntitlementView" : {
            view: "org/forgerock/openidm/ui/common/resource/EditResourceView",
            role: "ui-admin",
            url: /^resource\/(managed)\/(role)\/edit\/(.+)\/(.+)$/,
            pattern: "resource/?/?/edit/?/?"
        },
        "processListView" : {
            view: "org/forgerock/openidm/ui/admin/workflow/ProcessListView",
            role: "ui-admin",
            url: "workflow/processes/"
        },
        "taskListView" : {
            view: "org/forgerock/openidm/ui/admin/workflow/TaskListView",
            role: "ui-admin",
            url: "workflow/tasks/"
        },
        "taskInstanceView" : {
            view: "org/forgerock/openidm/ui/admin/workflow/TaskInstanceView",
            role: "ui-admin",
            url: /^workflow\/taskinstance\/(.+)$/,
            pattern: "workflow/taskinstance/?"
        },
        "processInstanceView" : {
            view: "org/forgerock/openidm/ui/admin/workflow/ProcessInstanceView",
            role: "ui-admin",
            url: /^workflow\/processinstance\/(.+)$/,
            pattern: "workflow/processinstance/?"
        },
        "processDefinitionView" : {
            view: "org/forgerock/openidm/ui/admin/workflow/ProcessDefinitionView",
            role: "ui-admin",
            url: /^workflow\/processdefinition\/(.+)$/,
            pattern: "workflow/processdefinition/?"
        },
        "apiExplorerView" : {
            view: "org/forgerock/openidm/ui/admin/api/ApiExplorerView",
            role: "ui-admin",
            url: /^apiExplorer$/,
            pattern: "apiExplorer"
        },
        "socialView" : {
            view: "org/forgerock/openidm/ui/admin/social/SocialConfigView",
            role: "ui-admin",
            url: "social/"
        },
        "scheduler" : {
            view: "org/forgerock/openidm/ui/admin/scheduler/SchedulerListView",
            role: "ui-admin",
            url: "scheduler/"
        },
        "editSchedulerView" : {
            view: "org/forgerock/openidm/ui/admin/scheduler/EditSchedulerView",
            role: "ui-admin",
            defaults : ["", ""],
            url: /^scheduler\/edit\/(.+?)\/(.*)$/,
            pattern: "scheduler/edit/?/?"
        },
        "addSchedulerView" : {
            view: "org/forgerock/openidm/ui/admin/scheduler/AddSchedulerView",
            role: "ui-admin",
            url: "scheduler/add/"
        },
        "emailSettingsView" : {
            view: "org/forgerock/openidm/ui/admin/email/EmailSettingsView",
            role: "ui-admin",
            url: /^emailsettings\/(.*)$/,
            pattern: "emailsettings/?/",
            defaults: ["provider"]
        },
        "emailTemplateView" : {
            view: "org/forgerock/openidm/ui/admin/email/EmailTemplateView",
            role: "ui-admin",
            url: /^emailTemplate\/(.+)$/,
            pattern: "emailTemplate/?"
        }
    };

    return obj;
});

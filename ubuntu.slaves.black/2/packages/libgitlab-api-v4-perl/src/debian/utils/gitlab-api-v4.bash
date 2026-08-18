
_gitlab_api_v4 () {
  COMPREPLY=()
  _get_comp_words_by_ref cur
  if [[ "${COMP_CWORD}" = 1 ]] ; then
    COMPREPLY=( $(compgen -W "issue-award-emojis merge-request-award-emojis snippet-award-emojis issue-award-emoji merge-request-award-emoji snippet-award-emoji create-issue-award-emoji create-merge-request-award-emoji create-snippet-award-emoji delete-issue-award-emoji delete-merge-request-award-emoji delete-snippet-award-emoji issue-note-award-emojis issue-note-award-emoji create-issue-note-award-emoji delete-issue-note-award-emoji merge-request-note-award-emojis merge-request-note-award-emoji create-merge-request-note-award-emoji delete-merge-request-note-award-emoji branches branch create-branch delete-branch delete-merged-branches broadcast-messages broadcast-message create-broadcast-message edit-broadcast-message delete-broadcast-message project-variables project-variable create-project-variable edit-project-variable delete-project-variable group-variables group-variable create-group-variable edit-group-variable delete-group-variable snippets snippet create-snippet edit-snippet delete-snippet public-snippets snippet-user-agent-detail commits create-commit commit commit-refs cherry-pick-commit commit-diff commit-comments create-commit-comment commit-statuses create-commit-status registry-repositories-in-project registry-repositories-in-group delete-registry-repository registry-repository-tags registry-repository-tag delete-registry-repository-tag bulk-delete-registry-repository-tags custom-user-attributes custom-group-attributes custom-project-attributes custom-user-attribute custom-group-attribute custom-project-attribute set-custom-user-attribute set-custom-group-attribute set-custom-project-attribute delete-custom-user-attribute delete-custom-group-attribute delete-custom-project-attribute deployments deployment all-deploy-keys deploy-keys deploy-key create-deploy-key delete-deploy-key enable-deploy-key environments create-environment edit-environment delete-environment stop-environment all-events user-events project-events features set-feature gitignores-templates gitignores-template gitlab-ci-ymls-templates gitlab-ci-ymls-template groups group-subgroups group-projects group create-group transfer-project-to-group edit-group delete-group sync-group-with-ldap create-ldap-group-link delete-ldap-group-link delete-ldap-provider-group-link group-access-requests request-group-access approve-group-access deny-group-access group-badges group-badge create-group-badge edit-group-badge delete-group-badge preview-group-badge group-members all-group-members group-member add-group-member update-group-member remove-group-member global-issues group-issues issues issue create-issue edit-issue delete-issue move-issue subscribe-to-issue unsubscribe-from-issue create-issue-todo set-issue-time-estimate reset-issue-time-estimate add-issue-spent-time reset-issue-spent-time issue-time-stats issue-closed-by issue-user-agent-detail project-boards project-board-lists project-board-list create-project-board-list edit-project-board-list delete-project-board-list group-boards group-board group-board-lists group-board-list create-group-board-list edit-group-board-list delete-group-board-list jobs pipeline-jobs job job-artifacts job-artifacts-archive job-artifacts-file job-trace-file cancel-job retry-job erase-job keep-job-artifacts play-job key labels create-label delete-label edit-label subscribe-to-label unsubscribe-from-label markdown global-merge-requests merge-requests merge-request merge-request-commits merge-request-with-changes create-merge-request edit-merge-request delete-merge-request accept-merge-request cancel-merge-when-pipeline-succeeds merge-request-closes-issues subscribe-to-merge-request unsubscribe-from-merge-request create-merge-request-todo merge-request-diff-versions merge-request-diff-version set-merge-request-time-estimate reset-merge-request-time-estimate add-merge-request-spent-time reset-merge-request-spent-time merge-request-time-stats project-milestones project-milestone create-project-milestone edit-project-milestone project-milestone-issues project-milestone-merge-requests group-milestones group-milestone create-group-milestone edit-group-milestone group-milestone-issues group-milestone-merge-requests namespaces namespace issue-notes issue-note create-issue-note edit-issue-note delete-issue-note snippet-notes snippet-note create-snippet-note edit-snippet-note delete-snippet-note merge-request-notes merge-request-note create-merge-request-note edit-merge-request-note delete-merge-request-note issue-discussions issue-discussion create-issue-discussion create-issue-discussion-note edit-issue-discussion-note delete-issue-discussion-note project-snippet-discussions project-snippet-discussion create-project-snippet-discussion create-project-snippet-discussion-note edit-project-snippet-discussion-note delete-project-snippet-discussion-note merge-request-discussions merge-request-discussion create-merge-request-discussion resolve-merge-request-discussion create-merge-request-discussion-note edit-merge-request-discussion-note delete-merge-request-discussion-note commit-discussions commit-discussion create-commit-discussion create-commit-discussion-note edit-commit-discussion-note delete-commit-discussion-note issue-resource-label-events issue-resource-label-event merge-request-resource-label-events merge-request-resource-label-event global-notification-settings set-global-notification-settings group-notification-settings project-notification-settings set-group-notification-settings set-project-notification-settings license-templates license-template global-pages-domains pages-domains pages-domain create-pages-domain edit-pages-domain delete-pages-domain pipelines pipeline create-pipeline retry-pipeline-jobs cancel-pipeline-jobs delete-pipeline triggers trigger create-trigger edit-trigger take-ownership-of-trigger delete-trigger trigger-pipeline pipeline-schedules pipeline-schedule create-pipeline-schedule edit-pipeline-schedule take-ownership-of-pipeline-schedule delete-pipeline-schedule create-pipeline-schedule-variable edit-pipeline-schedule-variable delete-pipeline-schedule-variable projects user-projects project project-users create-project create-project-for-user edit-project fork-project project-forks start-project unstar-project project-languages archive-project unarchive-project delete-project upload-file-to-project share-project-with-group unshare-project-with-group project-hooks project-hook create-project-hook edit-project-hook delete-project-hook set-project-fork clear-project-fork start-housekeeping transfer-project-to-namespace project-access-requests request-project-access approve-project-access deny-project-access project-badges project-badge create-project-badge edit-project-badge delete-project-badge preview-project-badge schedule-project-export project-export-status download-project-export schedule-project-import project-import-status project-members all-project-members project-member add-project-member update-project-member remove-project-member project-snippets project-snippet create-project-snippet edit-project-snippet delete-project-snippet project-snippet-content project-snippet-user-agent-detail protected-branches protected-branch protect-branch unprotect-branch protected-tags protected-tag protect-tag unprotect-tag releases release create-release update-release delete-release release-links release-link create-release-link update-release-link delete-release-link tree blob raw-blob archive compare contributors file raw-file create-file edit-file delete-file runners all-runners runner update-runner delete-runner runner-jobs project-runners enable-project-runner disable-project-runner search project-service edit-project-service delete-project-service settings update-settings statistics queue-metrics process-metrics job-stats compound-metrics hooks create-hook test-hook delete-hook tags tag create-tag delete-tag create-tag-release update-tag-release todos mark-todo-done mark-all-todos-done users user create-user edit-user delete-user current-user current-user-ssh-keys user-ssh-keys user-ssh-key create-current-user-ssh-key create-user-ssh-key delete-current-user-ssh-key delete-user-ssh-key current-user-gpg-keys current-user-gpg-key create-current-user-gpg-key delete-current-user-gpg-key user-gpg-keys user-gpg-key create-user-gpg-key delete-user-gpg-key current-user-emails user-emails current-user-email create-current-user-email create-user-email delete-current-user-email delete-user-email block-user unblock-user user-impersonation-tokens user-impersonation-token create-user-impersonation-token delete-user-impersonation-token all-user-activities user-memberships lint version wiki-pages wiki-page create-wiki-page edit-wiki-page delete-wiki-page" -- "${cur}") )
    return 0
  fi
  case "${COMP_WORDS[1]}" in


        (issue-award-emojis)
            COMPREPLY=( $(compgen -o nospace -W "iid: merge_request_iid: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (merge-request-award-emojis)
            COMPREPLY=( $(compgen -o nospace -W "iid: issue_iid: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (snippet-award-emojis)
            COMPREPLY=( $(compgen -o nospace -W "iid: issue_iid: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (issue-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: merge_request_iid: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (merge-request-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: issue_iid: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (snippet-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: issue_iid: merge_request_iid:" -- "${cur}") )
            return 0
            ;;
        

        (create-issue-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: merge_request_iid: name: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (create-merge-request-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: issue_iid: name: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (create-snippet-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: issue_iid: merge_request_iid: name:" -- "${cur}") )
            return 0
            ;;
        

        (delete-issue-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: merge_request_iid: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (delete-merge-request-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: issue_iid: snippet_id:" -- "${cur}") )
            return 0
            ;;
        

        (delete-snippet-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "iid: issue_iid: merge_request_iid:" -- "${cur}") )
            return 0
            ;;
        

        (create-issue-note-award-emoji)
            COMPREPLY=( $(compgen -o nospace -W "name:" -- "${cur}") )
            return 0
            ;;
        

        (branches)
            COMPREPLY=( $(compgen -o nospace -W "search: term:" -- "${cur}") )
            return 0
            ;;
        

        (create-branch)
            COMPREPLY=( $(compgen -o nospace -W "branch: ref:" -- "${cur}") )
            return 0
            ;;
        

        (create-broadcast-message)
            COMPREPLY=( $(compgen -o nospace -W "broadcast_type: color: dismissable: ends_at: font: message: starts_at: target_path:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-variable)
            COMPREPLY=( $(compgen -o nospace -W "_: env_var: environment_scope: file: key: masked: protected: value: variable_type:" -- "${cur}") )
            return 0
            ;;
        

        (create-group-variable)
            COMPREPLY=( $(compgen -o nospace -W "_: env_var: file: key: masked: protected: value: variable_type:" -- "${cur}") )
            return 0
            ;;
        

        (create-snippet)
            COMPREPLY=( $(compgen -o nospace -W "content: description: file_name: files: title: visibility:" -- "${cur}") )
            return 0
            ;;
        

        (public-snippets)
            COMPREPLY=( $(compgen -o nospace -W "page: per_page:" -- "${cur}") )
            return 0
            ;;
        

        (commits)
            COMPREPLY=( $(compgen -o nospace -W "all: default: first_parent: order: path: ref_name: since: topo: until: with_stats:" -- "${cur}") )
            return 0
            ;;
        

        (create-commit)
            COMPREPLY=( $(compgen -o nospace -W "action: author_email: author_name: branch: chmod: commit_message: content: create: delete: encoding: execute_filemode: file_path: force: last_commit_id: move: previous_path: start_branch: start_project: start_sha: stats: text: true: update:" -- "${cur}") )
            return 0
            ;;
        

        (registry-repositories-in-project)
            COMPREPLY=( $(compgen -o nospace -W "tags: tags_count:" -- "${cur}") )
            return 0
            ;;
        

        (registry-repositories-in-group)
            COMPREPLY=( $(compgen -o nospace -W "tags: tags_count:" -- "${cur}") )
            return 0
            ;;
        

        (deployments)
            COMPREPLY=( $(compgen -o nospace -W "asc: created_at: desc: environment: iid: order_by: ref: sort: status: updated_after: updated_at: updated_before:" -- "${cur}") )
            return 0
            ;;
        

        (create-deploy-key)
            COMPREPLY=( $(compgen -o nospace -W "can_push: key: title:" -- "${cur}") )
            return 0
            ;;
        

        (environments)
            COMPREPLY=( $(compgen -o nospace -W "available: name: search: states: stopped:" -- "${cur}") )
            return 0
            ;;
        

        (create-environment)
            COMPREPLY=( $(compgen -o nospace -W "external_url: name:" -- "${cur}") )
            return 0
            ;;
        

        (edit-environment)
            COMPREPLY=( $(compgen -o nospace -W "environment_id: external_url: name:" -- "${cur}") )
            return 0
            ;;
        

        (all-events)
            COMPREPLY=( $(compgen -o nospace -W "action: after: asc: before: created_at: desc: scope: sort: target_type:" -- "${cur}") )
            return 0
            ;;
        

        (user-events)
            COMPREPLY=( $(compgen -o nospace -W "action: after: asc: before: created_at: desc: sort: target_type:" -- "${cur}") )
            return 0
            ;;
        

        (project-events)
            COMPREPLY=( $(compgen -o nospace -W "action: after: asc: before: created_at: desc: description_html: sort: target_type:" -- "${cur}") )
            return 0
            ;;
        

        (set-feature)
            COMPREPLY=( $(compgen -o nospace -W "false: feature_group: group: key: percentage_of_actors: percentage_of_time: project: true: user: value:" -- "${cur}") )
            return 0
            ;;
        

        (group-projects)
            COMPREPLY=( $(compgen -o nospace -W "archived: asc: created_at: desc: false: include_subgroups: internal: last_activity_at: min_access_level: name: namespace: order_by: owned: path: private: public: search: similarity: similarity_search: simple: sort: starred: true: updated_at: visibility: with_custom_attributes: with_issues_enabled: with_merge_requests_enabled: with_security_reports: with_shared:" -- "${cur}") )
            return 0
            ;;
        

        (create-ldap-group-link)
            COMPREPLY=( $(compgen -o nospace -W "cn: filter: group_access: provider:" -- "${cur}") )
            return 0
            ;;
        

        (delete-ldap-group-link)
            COMPREPLY=( $(compgen -o nospace -W "provider:" -- "${cur}") )
            return 0
            ;;
        

        (approve-group-access)
            COMPREPLY=( $(compgen -o nospace -W "access_level:" -- "${cur}") )
            return 0
            ;;
        

        (group-badges)
            COMPREPLY=( $(compgen -o nospace -W "name:" -- "${cur}") )
            return 0
            ;;
        

        (create-group-badge)
            COMPREPLY=( $(compgen -o nospace -W "image_url: link_url:" -- "${cur}") )
            return 0
            ;;
        

        (edit-group-badge)
            COMPREPLY=( $(compgen -o nospace -W "image_url: link_url:" -- "${cur}") )
            return 0
            ;;
        

        (preview-group-badge)
            COMPREPLY=( $(compgen -o nospace -W "image_url: link_url:" -- "${cur}") )
            return 0
            ;;
        

        (group-members)
            COMPREPLY=( $(compgen -o nospace -W "query: user_ids:" -- "${cur}") )
            return 0
            ;;
        

        (all-group-members)
            COMPREPLY=( $(compgen -o nospace -W "query: user_ids:" -- "${cur}") )
            return 0
            ;;
        

        (add-group-member)
            COMPREPLY=( $(compgen -o nospace -W "access_level: expires_at: user_id:" -- "${cur}") )
            return 0
            ;;
        

        (update-group-member)
            COMPREPLY=( $(compgen -o nospace -W "access_level: expires_at:" -- "${cur}") )
            return 0
            ;;
        

        (global-issues)
            COMPREPLY=( $(compgen -o nospace -W "all: asc: assigned_to_me: assignee: assignee_id: assignee_username: assignees: author_id: author_username: closed: closed_by: confidential: created_after: created_at: created_before: created_by_me: desc: description: description_html: due_date: emoji: false: health_status: id: iid: in: label_priority: labels: milestone: milestone_due: month: my_reaction_emoji: next_month_and_previous_two_weeks: non_archived: not: opened: order_by: overdue: popularity: priority: relative_position: scope: search: sort: state: title: true: updated_after: updated_at: updated_before: username: week: weight: with_labels_details:" -- "${cur}") )
            return 0
            ;;
        

        (group-issues)
            COMPREPLY=( $(compgen -o nospace -W "all: asc: assigned_to_me: assignee: assignee_id: assignee_username: assignees: author_id: author_username: closed: closed_by: confidential: created_after: created_at: created_before: created_by_me: desc: description: description_html: due_date: emoji: false: health_status: iid: in: label_priority: labels: milestone: milestone_due: month: my_reaction_emoji: next_month_and_previous_two_weeks: non_archived: not: opened: order_by: overdue: popularity: priority: relative_position: scope: search: sort: state: title: true: updated_after: updated_at: updated_before: username: week: weight: with_labels_details:" -- "${cur}") )
            return 0
            ;;
        

        (create-issue)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at:" -- "${cur}") )
            return 0
            ;;
        

        (edit-issue)
            COMPREPLY=( $(compgen -o nospace -W "body:" -- "${cur}") )
            return 0
            ;;
        

        (move-issue)
            COMPREPLY=( $(compgen -o nospace -W "assignee: assignees: closed_by: health_status: to_project_id: weight:" -- "${cur}") )
            return 0
            ;;
        

        (subscribe-to-issue)
            COMPREPLY=( $(compgen -o nospace -W "assignee: assignees: closed_by: weight:" -- "${cur}") )
            return 0
            ;;
        

        (create-issue-todo)
            COMPREPLY=( $(compgen -o nospace -W "assignee: assignees: closed_by:" -- "${cur}") )
            return 0
            ;;
        

        (set-issue-time-estimate)
            COMPREPLY=( $(compgen -o nospace -W "duration:" -- "${cur}") )
            return 0
            ;;
        

        (add-issue-spent-time)
            COMPREPLY=( $(compgen -o nospace -W "duration:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-board-list)
            COMPREPLY=( $(compgen -o nospace -W "assignee_id: label_id: milestone_id:" -- "${cur}") )
            return 0
            ;;
        

        (edit-project-board-list)
            COMPREPLY=( $(compgen -o nospace -W "position:" -- "${cur}") )
            return 0
            ;;
        

        (create-group-board-list)
            COMPREPLY=( $(compgen -o nospace -W "label_id:" -- "${cur}") )
            return 0
            ;;
        

        (edit-group-board-list)
            COMPREPLY=( $(compgen -o nospace -W "position:" -- "${cur}") )
            return 0
            ;;
        

        (jobs)
            COMPREPLY=( $(compgen -o nospace -W "job_token: script:" -- "${cur}") )
            return 0
            ;;
        

        (pipeline-jobs)
            COMPREPLY=( $(compgen -o nospace -W "canceled: created: failed: manual: pending: running: scope: skipped: success:" -- "${cur}") )
            return 0
            ;;
        

        (job)
            COMPREPLY=( $(compgen -o nospace -W "job_token: script:" -- "${cur}") )
            return 0
            ;;
        

        (job-artifacts)
            COMPREPLY=( $(compgen -o nospace -W "job_token: script:" -- "${cur}") )
            return 0
            ;;
        

        (job-artifacts-archive)
            COMPREPLY=( $(compgen -o nospace -W "job: job_token: master: script: test:" -- "${cur}") )
            return 0
            ;;
        

        (labels)
            COMPREPLY=( $(compgen -o nospace -W "false: include_ancestor_groups: true: with_counts:" -- "${cur}") )
            return 0
            ;;
        

        (create-label)
            COMPREPLY=( $(compgen -o nospace -W "color: description: name: null: priority:" -- "${cur}") )
            return 0
            ;;
        

        (delete-label)
            COMPREPLY=( $(compgen -o nospace -W "name:" -- "${cur}") )
            return 0
            ;;
        

        (edit-label)
            COMPREPLY=( $(compgen -o nospace -W "color: description: name: new_name: null: priority:" -- "${cur}") )
            return 0
            ;;
        

        (global-merge-requests)
            COMPREPLY=( $(compgen -o nospace -W "all: approvals_before_merge: approved_by_ids: approver_ids: asc: assigned_to_me: assignee_id: assignee_username: author_id: author_username: cannot_be_merged: closed: created_after: created_at: created_before: created_by_me: deployed_after: deployed_before: desc: description: emoji: environment: false: has_conflicts: id: iid: in: labels: locked: merge_status: merged: milestone: my_reaction_emoji: no: not: opened: order_by: scope: search: simple: sort: source_branch: state: target_branch: title: true: updated_after: updated_at: updated_before: username: view: wip: with_labels_details: with_merge_status_recheck: yes:" -- "${cur}") )
            return 0
            ;;
        

        (create-merge-request)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at: position:" -- "${cur}") )
            return 0
            ;;
        

        (edit-merge-request)
            COMPREPLY=( $(compgen -o nospace -W "resolved:" -- "${cur}") )
            return 0
            ;;
        

        (accept-merge-request)
            COMPREPLY=( $(compgen -o nospace -W "approvals_before_merge: merge_commit_message: merge_when_pipeline_succeeds: sha: should_remove_source_branch: squash: squash_commit_message: true:" -- "${cur}") )
            return 0
            ;;
        

        (subscribe-to-merge-request)
            COMPREPLY=( $(compgen -o nospace -W "approvals_before_merge:" -- "${cur}") )
            return 0
            ;;
        

        (unsubscribe-from-merge-request)
            COMPREPLY=( $(compgen -o nospace -W "approvals_before_merge:" -- "${cur}") )
            return 0
            ;;
        

        (set-merge-request-time-estimate)
            COMPREPLY=( $(compgen -o nospace -W "duration:" -- "${cur}") )
            return 0
            ;;
        

        (add-merge-request-spent-time)
            COMPREPLY=( $(compgen -o nospace -W "duration:" -- "${cur}") )
            return 0
            ;;
        

        (project-milestones)
            COMPREPLY=( $(compgen -o nospace -W "active: closed: iid: include_parent_milestones: search: state: title: true:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-milestone)
            COMPREPLY=( $(compgen -o nospace -W "description: due_date: start_date: title:" -- "${cur}") )
            return 0
            ;;
        

        (edit-project-milestone)
            COMPREPLY=( $(compgen -o nospace -W "description: due_date: start_date: state_event: title:" -- "${cur}") )
            return 0
            ;;
        

        (group-milestones)
            COMPREPLY=( $(compgen -o nospace -W "active: closed: iid: include_parent_milestones: search: state: title: true:" -- "${cur}") )
            return 0
            ;;
        

        (create-group-milestone)
            COMPREPLY=( $(compgen -o nospace -W "description: due_date: start_date: title:" -- "${cur}") )
            return 0
            ;;
        

        (edit-group-milestone)
            COMPREPLY=( $(compgen -o nospace -W "activate: close: description: due_date: start_date: state_event: title:" -- "${cur}") )
            return 0
            ;;
        

        (namespaces)
            COMPREPLY=( $(compgen -o nospace -W "max_seats_used: members_count_with_descendants: plan: seats_in_use:" -- "${cur}") )
            return 0
            ;;
        

        (create-issue-note)
            COMPREPLY=( $(compgen -o nospace -W "name:" -- "${cur}") )
            return 0
            ;;
        

        (edit-issue-note)
            COMPREPLY=( $(compgen -o nospace -W "body: confidential:" -- "${cur}") )
            return 0
            ;;
        

        (snippet-notes)
            COMPREPLY=( $(compgen -o nospace -W "asc: created_at: desc: order_by: sort: updated_at:" -- "${cur}") )
            return 0
            ;;
        

        (create-snippet-note)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at:" -- "${cur}") )
            return 0
            ;;
        

        (edit-snippet-note)
            COMPREPLY=( $(compgen -o nospace -W "body:" -- "${cur}") )
            return 0
            ;;
        

        (merge-request-notes)
            COMPREPLY=( $(compgen -o nospace -W "asc: created_at: desc: order_by: sort: updated_at:" -- "${cur}") )
            return 0
            ;;
        

        (create-merge-request-note)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at:" -- "${cur}") )
            return 0
            ;;
        

        (edit-merge-request-note)
            COMPREPLY=( $(compgen -o nospace -W "body:" -- "${cur}") )
            return 0
            ;;
        

        (create-issue-discussion)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at:" -- "${cur}") )
            return 0
            ;;
        

        (create-issue-discussion-note)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at: note_id:" -- "${cur}") )
            return 0
            ;;
        

        (edit-issue-discussion-note)
            COMPREPLY=( $(compgen -o nospace -W "body:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-snippet-discussion)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-snippet-discussion-note)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at: note_id:" -- "${cur}") )
            return 0
            ;;
        

        (edit-project-snippet-discussion-note)
            COMPREPLY=( $(compgen -o nospace -W "body:" -- "${cur}") )
            return 0
            ;;
        

        (create-merge-request-discussion)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at: position:" -- "${cur}") )
            return 0
            ;;
        

        (resolve-merge-request-discussion)
            COMPREPLY=( $(compgen -o nospace -W "resolved:" -- "${cur}") )
            return 0
            ;;
        

        (create-merge-request-discussion-note)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at: note_id:" -- "${cur}") )
            return 0
            ;;
        

        (edit-merge-request-discussion-note)
            COMPREPLY=( $(compgen -o nospace -W "body: resolved:" -- "${cur}") )
            return 0
            ;;
        

        (create-commit-discussion)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at: position:" -- "${cur}") )
            return 0
            ;;
        

        (create-commit-discussion-note)
            COMPREPLY=( $(compgen -o nospace -W "body: created_at: note_id:" -- "${cur}") )
            return 0
            ;;
        

        (edit-commit-discussion-note)
            COMPREPLY=( $(compgen -o nospace -W "body:" -- "${cur}") )
            return 0
            ;;
        

        (set-global-notification-settings)
            COMPREPLY=( $(compgen -o nospace -W "close_issue: close_merge_request: failed_pipeline: fixed_pipeline: issue_due: level: merge_merge_request: moved_project: new_epic: new_issue: new_merge_request: new_note: notification_email: push_to_merge_request: reassign_issue: reassign_merge_request: reopen_issue: reopen_merge_request: success_pipeline:" -- "${cur}") )
            return 0
            ;;
        

        (set-group-notification-settings)
            COMPREPLY=( $(compgen -o nospace -W "close_issue: close_merge_request: failed_pipeline: fixed_pipeline: issue_due: level: merge_merge_request: moved_project: new_epic: new_issue: new_merge_request: new_note: push_to_merge_request: reassign_issue: reassign_merge_request: reopen_issue: reopen_merge_request: success_pipeline:" -- "${cur}") )
            return 0
            ;;
        

        (set-project-notification-settings)
            COMPREPLY=( $(compgen -o nospace -W "close_issue: close_merge_request: failed_pipeline: fixed_pipeline: issue_due: level: merge_merge_request: moved_project: new_epic: new_issue: new_merge_request: new_note: push_to_merge_request: reassign_issue: reassign_merge_request: reopen_issue: reopen_merge_request: success_pipeline:" -- "${cur}") )
            return 0
            ;;
        

        (license-templates)
            COMPREPLY=( $(compgen -o nospace -W "popular:" -- "${cur}") )
            return 0
            ;;
        

        (create-pages-domain)
            COMPREPLY=( $(compgen -o nospace -W "auto_ssl_enabled: certificate: domain: key:" -- "${cur}") )
            return 0
            ;;
        

        (edit-pages-domain)
            COMPREPLY=( $(compgen -o nospace -W "auto_ssl_enabled: certificate: key:" -- "${cur}") )
            return 0
            ;;
        

        (pipelines)
            COMPREPLY=( $(compgen -o nospace -W "asc: branches: canceled: created: desc: failed: finished: manual: name: order_by: pending: preparing: ref: running: scheduled: scope: sha: skipped: sort: status: success: tags: updated_after: updated_at: updated_before: user_id: username: waiting_for_resource: yaml_errors:" -- "${cur}") )
            return 0
            ;;
        

        (create-pipeline)
            COMPREPLY=( $(compgen -o nospace -W "ref: variables:" -- "${cur}") )
            return 0
            ;;
        

        (create-trigger)
            COMPREPLY=( $(compgen -o nospace -W "description:" -- "${cur}") )
            return 0
            ;;
        

        (edit-trigger)
            COMPREPLY=( $(compgen -o nospace -W "description:" -- "${cur}") )
            return 0
            ;;
        

        (pipeline-schedules)
            COMPREPLY=( $(compgen -o nospace -W "active: inactive: scope:" -- "${cur}") )
            return 0
            ;;
        

        (create-pipeline-schedule)
            COMPREPLY=( $(compgen -o nospace -W "active: cron: cron_timezone: description: ref: true:" -- "${cur}") )
            return 0
            ;;
        

        (edit-pipeline-schedule)
            COMPREPLY=( $(compgen -o nospace -W "active: cron: cron_timezone: description: ref:" -- "${cur}") )
            return 0
            ;;
        

        (create-pipeline-schedule-variable)
            COMPREPLY=( $(compgen -o nospace -W "_: env_var: file: key: value: variable_type:" -- "${cur}") )
            return 0
            ;;
        

        (projects)
            COMPREPLY=( $(compgen -o nospace -W "active: closed: iid: include_parent_milestones: search: state: title: true:" -- "${cur}") )
            return 0
            ;;
        

        (user-projects)
            COMPREPLY=( $(compgen -o nospace -W "archived: asc: created_at: desc: id: id_after: id_before: internal: last_activity_at: membership: min_access_level: name: order_by: owned: path: private: public: search: simple: sort: starred: statistics: updated_at: visibility: with_custom_attributes: with_issues_enabled: with_merge_requests_enabled: with_programming_language:" -- "${cur}") )
            return 0
            ;;
        

        (project)
            COMPREPLY=( $(compgen -o nospace -W "action: after: asc: before: created_at: desc: description_html: sort: target_type:" -- "${cur}") )
            return 0
            ;;
        

        (project-users)
            COMPREPLY=( $(compgen -o nospace -W "search: skip_users:" -- "${cur}") )
            return 0
            ;;
        

        (create-project)
            COMPREPLY=( $(compgen -o nospace -W "description: due_date: start_date: title:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-for-user)
            COMPREPLY=( $(compgen -o nospace -W "allow_merge_on_skipped_pipeline: api: approvals_before_merge: auto_cancel_pending_pipelines: auto_devops_deploy_strategy: auto_devops_enabled: autoclose_referenced_issues: avatar: build_coverage_regex: build_git_strategy: build_timeout: builds_access_level: ci_config_path: container_registry_enabled: continuous: description: disabled: emails_disabled: enabled: external_authorization_classification_label: false: fetch: forking_access_level: group_with_project_templates_id: import_url: initialize_with_readme: issues_access_level: issues_enabled: jobs_enabled: lfs_enabled: manual: merge_method: merge_requests_access_level: merge_requests_enabled: mirror: mirror_trigger_builds: name: namespace_id: only_allow_merge_if_all_discussions_are_resolved: only_allow_merge_if_pipeline_succeeds: packages_enabled: pages_access_level: password: path: printing_merge_request_link_enabled: private: public: public_builds: remove_source_branch_after_merge: repository_access_level: repository_storage: request_access_enabled: resolve_outdated_diff_discussions: shared_runners_enabled: show_default_award_emojis: snippets_access_level: snippets_enabled: suggestion_commit_message: tag_list: template_name: timed_incremental: true: use_custom_template: visibility: wiki_access_level: wiki_enabled:" -- "${cur}") )
            return 0
            ;;
        

        (fork-project)
            COMPREPLY=( $(compgen -o nospace -W "name: namespace: namespace_id: namespace_path: path:" -- "${cur}") )
            return 0
            ;;
        

        (project-forks)
            COMPREPLY=( $(compgen -o nospace -W "archived: asc: created_at: desc: internal: last_activity_at: membership: min_access_level: name: order_by: owned: path: private: public: search: simple: sort: starred: statistics: updated_at: visibility: with_custom_attributes: with_issues_enabled: with_merge_requests_enabled:" -- "${cur}") )
            return 0
            ;;
        

        (upload-file-to-project)
            COMPREPLY=( $(compgen -o nospace -W "file: full_path: markdown: url:" -- "${cur}") )
            return 0
            ;;
        

        (share-project-with-group)
            COMPREPLY=( $(compgen -o nospace -W "expires_at: group_access: group_id:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-hook)
            COMPREPLY=( $(compgen -o nospace -W "confidential_issues_events: confidential_note_events: deployment_events: enable_ssl_verification: issues_events: job_events: merge_requests_events: note_events: pipeline_events: push_events: push_events_branch_filter: tag_push_events: token: url: wiki_page_events:" -- "${cur}") )
            return 0
            ;;
        

        (edit-project-hook)
            COMPREPLY=( $(compgen -o nospace -W "confidential_issues_events: confidential_note_events: deployment_events: enable_ssl_verification: issues_events: job_events: merge_requests_events: note_events: pipeline_events: push_events: push_events_branch_filter: tag_push_events: token: url: wiki_events:" -- "${cur}") )
            return 0
            ;;
        

        (transfer-project-to-namespace)
            COMPREPLY=( $(compgen -o nospace -W "namespace:" -- "${cur}") )
            return 0
            ;;
        

        (approve-project-access)
            COMPREPLY=( $(compgen -o nospace -W "access_level:" -- "${cur}") )
            return 0
            ;;
        

        (project-badges)
            COMPREPLY=( $(compgen -o nospace -W "name:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-badge)
            COMPREPLY=( $(compgen -o nospace -W "image_url: link_url:" -- "${cur}") )
            return 0
            ;;
        

        (edit-project-badge)
            COMPREPLY=( $(compgen -o nospace -W "image_url: link_url:" -- "${cur}") )
            return 0
            ;;
        

        (preview-project-badge)
            COMPREPLY=( $(compgen -o nospace -W "caller_id: code_review: completed: deleted_jobs: feature_category: image_url: issue_tracking: link_url: project: queue_name: queue_size: root_namespace: subscription_plan: user:" -- "${cur}") )
            return 0
            ;;
        

        (schedule-project-export)
            COMPREPLY=( $(compgen -o nospace -W "description: upload:" -- "${cur}") )
            return 0
            ;;
        

        (project-export-status)
            COMPREPLY=( $(compgen -o nospace -W "_links: created_at: finished: none: queued: regeneration_in_progress: started:" -- "${cur}") )
            return 0
            ;;
        

        (schedule-project-import)
            COMPREPLY=( $(compgen -o nospace -W "file: max_import_size: name: namespace: override_params: overwrite: path:" -- "${cur}") )
            return 0
            ;;
        

        (project-import-status)
            COMPREPLY=( $(compgen -o nospace -W "api: failed: failed_relations: finished: import_error: none: read_repository: scheduled: started:" -- "${cur}") )
            return 0
            ;;
        

        (project-members)
            COMPREPLY=( $(compgen -o nospace -W "query: user_ids:" -- "${cur}") )
            return 0
            ;;
        

        (all-project-members)
            COMPREPLY=( $(compgen -o nospace -W "query: user_ids:" -- "${cur}") )
            return 0
            ;;
        

        (add-project-member)
            COMPREPLY=( $(compgen -o nospace -W "access_level: expires_at: user_id:" -- "${cur}") )
            return 0
            ;;
        

        (update-project-member)
            COMPREPLY=( $(compgen -o nospace -W "access_level: expires_at:" -- "${cur}") )
            return 0
            ;;
        

        (remove-project-member)
            COMPREPLY=( $(compgen -o nospace -W "unassign_issuables:" -- "${cur}") )
            return 0
            ;;
        

        (create-project-snippet)
            COMPREPLY=( $(compgen -o nospace -W "content: description: file_name: files: title: visibility:" -- "${cur}") )
            return 0
            ;;
        

        (edit-project-snippet)
            COMPREPLY=( $(compgen -o nospace -W "content: description: file_name: files: title: visibility:" -- "${cur}") )
            return 0
            ;;
        

        (protected-branches)
            COMPREPLY=( $(compgen -o nospace -W "group_id: search: user_id:" -- "${cur}") )
            return 0
            ;;
        

        (protect-branch)
            COMPREPLY=( $(compgen -o nospace -W "allowed_to_merge: allowed_to_push: allowed_to_unprotect: code_owner_approval_required: group_id: merge_access_level: name: push_access_level: unprotect_access_level: user_id:" -- "${cur}") )
            return 0
            ;;
        

        (protect-tag)
            COMPREPLY=( $(compgen -o nospace -W "create_access_level: name:" -- "${cur}") )
            return 0
            ;;
        

        (create-release)
            COMPREPLY=( $(compgen -o nospace -W "image: link_type: name: other: package: runbook: url:" -- "${cur}") )
            return 0
            ;;
        

        (update-release)
            COMPREPLY=( $(compgen -o nospace -W "image: link_type: name: other: package: runbook: url:" -- "${cur}") )
            return 0
            ;;
        

        (create-release-link)
            COMPREPLY=( $(compgen -o nospace -W "image: link_type: name: other: package: runbook: url:" -- "${cur}") )
            return 0
            ;;
        

        (update-release-link)
            COMPREPLY=( $(compgen -o nospace -W "image: link_type: name: other: package: runbook: url:" -- "${cur}") )
            return 0
            ;;
        

        (tree)
            COMPREPLY=( $(compgen -o nospace -W "path: per_page: recursive: ref:" -- "${cur}") )
            return 0
            ;;
        

        (archive)
            COMPREPLY=( $(compgen -o nospace -W "format: sha: tar: tbz: zip:" -- "${cur}") )
            return 0
            ;;
        

        (compare)
            COMPREPLY=( $(compgen -o nospace -W "false: from: straight: to: true:" -- "${cur}") )
            return 0
            ;;
        

        (contributors)
            COMPREPLY=( $(compgen -o nospace -W "additions: asc: commits: deletions: desc: email: name: order_by: sort:" -- "${cur}") )
            return 0
            ;;
        

        (file)
            COMPREPLY=( $(compgen -o nospace -W "blob_id: ref:" -- "${cur}") )
            return 0
            ;;
        

        (raw-file)
            COMPREPLY=( $(compgen -o nospace -W "ref:" -- "${cur}") )
            return 0
            ;;
        

        (create-file)
            COMPREPLY=( $(compgen -o nospace -W "author_email: author_name: branch: commit_message: content: encoding: start_branch:" -- "${cur}") )
            return 0
            ;;
        

        (edit-file)
            COMPREPLY=( $(compgen -o nospace -W "author_email: author_name: branch: commit_message: content: encoding: last_commit_id: start_branch:" -- "${cur}") )
            return 0
            ;;
        

        (delete-file)
            COMPREPLY=( $(compgen -o nospace -W "author_email: author_name: branch: commit_message: last_commit_id: start_branch:" -- "${cur}") )
            return 0
            ;;
        

        (runners)
            COMPREPLY=( $(compgen -o nospace -W "active: group_type: instance_type: offline: online: paused: project_type: scope: status: tag_list: type:" -- "${cur}") )
            return 0
            ;;
        

        (all-runners)
            COMPREPLY=( $(compgen -o nospace -W "active: group_type: instance_type: offline: online: paused: project_type: scope: shared: specific: status: tag_list: type:" -- "${cur}") )
            return 0
            ;;
        

        (runner-jobs)
            COMPREPLY=( $(compgen -o nospace -W "asc: canceled: desc: failed: order_by: running: sort: status: success:" -- "${cur}") )
            return 0
            ;;
        

        (project-runners)
            COMPREPLY=( $(compgen -o nospace -W "active: group_type: instance_type: offline: online: paused: project_type: scope: status: tag_list: type:" -- "${cur}") )
            return 0
            ;;
        

        (enable-project-runner)
            COMPREPLY=( $(compgen -o nospace -W "runner_id:" -- "${cur}") )
            return 0
            ;;
        

        (search)
            COMPREPLY=( $(compgen -o nospace -W "confidential: scope: search: search_filter_by_confidential: state:" -- "${cur}") )
            return 0
            ;;
        

        (settings)
            COMPREPLY=( $(compgen -o nospace -W "deletion_adjourned_period: file_template_project_id: geo_node_allowed_ips:" -- "${cur}") )
            return 0
            ;;
        

        (update-settings)
            COMPREPLY=( $(compgen -o nospace -W "deletion_adjourned_period: file_template_project_id: geo_node_allowed_ips: geo_status_timeout:" -- "${cur}") )
            return 0
            ;;
        

        (create-hook)
            COMPREPLY=( $(compgen -o nospace -W "enable_ssl_verification: merge_requests_events: push_events: repository_update_events: tag_push_events: token: url:" -- "${cur}") )
            return 0
            ;;
        

        (tags)
            COMPREPLY=( $(compgen -o nospace -W "asc: desc: name: order_by: search: sort: term: updated:" -- "${cur}") )
            return 0
            ;;
        

        (create-tag)
            COMPREPLY=( $(compgen -o nospace -W "message: null: ref: release_description: tag_name:" -- "${cur}") )
            return 0
            ;;
        

        (create-tag-release)
            COMPREPLY=( $(compgen -o nospace -W "description:" -- "${cur}") )
            return 0
            ;;
        

        (update-tag-release)
            COMPREPLY=( $(compgen -o nospace -W "description:" -- "${cur}") )
            return 0
            ;;
        

        (todos)
            COMPREPLY=( $(compgen -o nospace -W "action: approval_required: assigned: author_id: build_failed: directly_addressed: done: group_id: marked: mentioned: merge_train_removed: pending: project_id: state: type: unmergeable:" -- "${cur}") )
            return 0
            ;;
        

        (users)
            COMPREPLY=( $(compgen -o nospace -W "active: blocked:" -- "${cur}") )
            return 0
            ;;
        

        (user)
            COMPREPLY=( $(compgen -o nospace -W "active: all: inactive: state:" -- "${cur}") )
            return 0
            ;;
        

        (create-user)
            COMPREPLY=( $(compgen -o nospace -W "admin: avatar: bio: can_create_group: color_scheme_id: email: extern_uid: external: extra_shared_runners_minutes_limit: force_random_password: group_id_for_saml: linkedin: location: name: nil: note: organization: password: private_profile: projects_limit: provider: public_email: reset_password: shared_runners_minutes_limit: skip_confirmation: skype: theme_id: twitter: username: website_url:" -- "${cur}") )
            return 0
            ;;
        

        (current-user)
            COMPREPLY=( $(compgen -o nospace -W "active: blocked:" -- "${cur}") )
            return 0
            ;;
        

        (create-current-user-ssh-key)
            COMPREPLY=( $(compgen -o nospace -W "expires_at: key: title:" -- "${cur}") )
            return 0
            ;;
        

        (create-user-ssh-key)
            COMPREPLY=( $(compgen -o nospace -W "expires_at: key: title:" -- "${cur}") )
            return 0
            ;;
        

        (create-user-gpg-key)
            COMPREPLY=( $(compgen -o nospace -W "key_id:" -- "${cur}") )
            return 0
            ;;
        

        (create-current-user-email)
            COMPREPLY=( $(compgen -o nospace -W "email:" -- "${cur}") )
            return 0
            ;;
        

        (create-user-email)
            COMPREPLY=( $(compgen -o nospace -W "email: skip_confirmation:" -- "${cur}") )
            return 0
            ;;
        

        (user-impersonation-tokens)
            COMPREPLY=( $(compgen -o nospace -W "active: all: inactive: state:" -- "${cur}") )
            return 0
            ;;
        

        (create-user-impersonation-token)
            COMPREPLY=( $(compgen -o nospace -W "api: expires_at: name: read_user: scopes:" -- "${cur}") )
            return 0
            ;;
        

        (all-user-activities)
            COMPREPLY=( $(compgen -o nospace -W "from: last_activity_at: last_activity_on:" -- "${cur}") )
            return 0
            ;;
        

        (user-memberships)
            COMPREPLY=( $(compgen -o nospace -W "type:" -- "${cur}") )
            return 0
            ;;
        

        (wiki-pages)
            COMPREPLY=( $(compgen -o nospace -W "with_content:" -- "${cur}") )
            return 0
            ;;
        

        (create-wiki-page)
            COMPREPLY=( $(compgen -o nospace -W "asciidoc: content: format: markdown: org: rdoc: title:" -- "${cur}") )
            return 0
            ;;
        

        (edit-wiki-page)
            COMPREPLY=( $(compgen -o nospace -W "asciidoc: content: format: markdown: org: rdoc: title:" -- "${cur}") )
            return 0
            ;;
        

  esac
}
complete -F _gitlab_api_v4 gitlab-api-v4


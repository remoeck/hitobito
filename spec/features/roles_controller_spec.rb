# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz, Pfadibewegung Schweiz.
#  This file is part of hitobito and licensed under the Affero General Public
#  License version 3 or later. See the COPYING file at the top-level
#  directory or at https://github.com/hitobito/hitobito.


require 'spec_helper'


describe RolesController, js: true do

  subject { page }
  let(:group) { groups(:top_group) }

  it 'toggles people fields' do
    obsolete_node_safe do
      sign_in
      visit new_group_role_path(group_id: group.id)
      should have_content('Person hinzufügen')
      should have_selector('#role_person', visible: true)
      should have_selector('#role_new_person_first_name', visible: false)

      click_link('Neue Person erfassen')
      should have_selector('#role_person', visible: false)
      should have_selector('#role_new_person_first_name', visible: true)

      click_link('Bestehende Person suchen')
      should have_selector('#role_person', visible: true)
      should have_selector('#role_new_person_first_name', visible: false)
    end
  end

  it 'uses exisiting person when given' do
    obsolete_node_safe do
      sign_in
      visit new_group_role_path(group_id: group.id)

      find('a.chosen-single').click
      find('ul.chosen-results').find('li', text: 'Leader').click

      # test user clicking around first
      click_link('Neue Person erfassen')
      fill_in('Vorname', with: 'Tester')

      # now search existing person
      click_link('Bestehende Person suchen')
      fill_in 'Person', with: 'Top'
      page.find('.typeahead.dropdown-menu li').click

      all('form .btn-toolbar').first.click_button 'Speichern'

      current_path.should == group_people_path(group)
      should have_content 'Rolle Leader für Top Leader in TopGroup wurde erfolgreich erstellt.'
    end
  end

  it 'creates new person when fields filled' do
    obsolete_node_safe do
      sign_in
      visit new_group_role_path(group_id: group.id)

      find('a.chosen-single').click
      find('ul.chosen-results').find('li', text: 'Leader').click

      # test user clicking around first
      fill_in 'Person', with: 'Top'
      sleep(0.5)
      find('.typeahead.dropdown-menu li').click

      # now define new person
      click_link('Neue Person erfassen')
      fill_in('Vorname', with: 'Tester')

      all('form .btn-toolbar').first.click_button 'Speichern'

      current_path.should_not == group_people_path(group)
      should have_content 'Rolle Leader für Tester in TopGroup wurde erfolgreich erstellt.'
    end
  end

  it 'updates info when type changes' do
    obsolete_node_safe do
      sign_in
      visit new_group_role_path(group_id: group.id)

      find('a.chosen-single').click
      find('ul.chosen-results').find('li', text: 'Leader').click

      find('#role_info').should have_content('Die Rolle Leader in der Gruppe TopGroup')

      find('a.chosen-single').click
      find('ul.chosen-results').find('li', text: 'Member').click

      find('#role_info').should have_content('Die Rolle Member in der Gruppe TopGroup')
    end
  end
end


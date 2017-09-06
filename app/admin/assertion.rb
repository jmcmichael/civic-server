ActiveAdmin.register Assertion do
  permit_params :name, :description, :nccn_guideline, :fda_approved, :fda_approval_information, evidence_item_ids: [], acmg_code_ids: []

  filter :name
  filter :acmg_codes
  filter :nccn_guideline
  filter :fda_approved
  filter :fda_approval_information

  form do |f|
    f.inputs do
      f.input :description
      f.input :fda_approved
      f.input :fda_approval_information
      f.input :nccn_guideline, input_html: {rows: 1}
      f.input :acmg_codes, as: :select, collection: AcmgCode.order(:code)
      f.input :evidence_items, as: :select, collection: EvidenceItem.order(:id).all
    end
    f.actions
  end

  controller do
    def scoped_collection
      resource_class.includes(:acmg_codes)
    end
  end

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :fda_approved
    column :fda_approval_information
    column :nccn_guidelines
    column :acmg_codes do |a|
      a.acmg_codes.map(&:code).join(',')
    end
    column :evidence_items do |a|
      a.evidence_items.map(&:name).sort.join(',')
    end
    actions
  end

  show do |f|
    attributes_table do
      row :description
      row :fda_approved
      row :fda_approval_information
      row :nccn_guidelines
      row :acmg_codes do |a|
        a.acmg_codes.map(&:code).join(',')
      end
      row :evidence_items do |a|
        a.evidence_items.map(&:name).sort.join(',')
      end
    end
  end
end
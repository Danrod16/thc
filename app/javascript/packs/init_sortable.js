import { Sortable, MultiDrag, Swap, OnSpill, AutoScroll } from "sortablejs";

const initSortable = () => {
  const list = document.querySelector('.sortable');
  const token = document.querySelector("meta[name='csrf-token']").getAttribute('content')
  Sortable.create(list, {
    group: "localStorage-example",
    delay: 750,
    delayOnTouchOnly: true,
    store: {
      /**
       * Get the order of elements. Called once during initialization.
       * @param   {Sortable}  sortable
       * @returns {Array}
       */
      //  get: function (sortable) {
      //   var order = localStorage.getItem(sortable.options.group.name);
      //   return order ? order.split("|") : [];
      // },

      /**
       * Save the order of elements. Called onEnd (when the item is dropped).
       * @param {Sortable}  sortable
       */
    set: function (sortable) {
        var order = sortable.toArray();
        const deliveryCategoryId = list.dataset.id;
        const url = `/delivery_categories/${deliveryCategoryId}/reorganize`

        fetch(url, {
          method: "POST",
          headers: {
            "content-type": "application/json",
            'X-CSRF-TOKEN': token
          },
          body: JSON.stringify({
            order_ids: order
          })
        })
      },
    },
  });
};


export { initSortable };

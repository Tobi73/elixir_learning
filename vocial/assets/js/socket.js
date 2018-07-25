import { Socket } from 'phoenix';

const pushVote = (el, channel) => {
  channel
    .push('vote', { option_id: el.getAttribute('data-option-id')})
    .receive('ok', res => console.log('You voted!'))
    .receive('error', res => console.log("failed to vote", res));
}

const onJoin = (res, channel) => {
  document.querySelectorAll('.vote-button-manual').forEach(el => {
    el.addEventListener('click', event => {
      event.preventDefault();
      pushVote(el, channel);
    })
  })
  console.log('Joined channel:', res);
}

const socket = new Socket("/socket")

socket.connect()

const enableSocket = document.getElementById('enable-polls-channel');

if (enableSocket) {
  const pollId = enableSocket.getAttribute('data-poll-id');
  const remoteIp = document.getElementsByName('remote_ip')[0].getAttribute('content');
  const channel = socket.channel('polls:' + pollId, {remote_ip: remoteIp});

  channel
    .join()
    .receive('ok', res => onJoin(res, channel))
    .receive('error', res => console.log('Failed to join channel', res));

  channel.on('pong', payload => {
    console.log('The server has been PONGd and all is well', payload);
  })

  channel.on('new-vote', ({option_id, votes}) => {
    console.log("new vote");
    document.getElementById('vote-count-' + option_id).innerHTML = votes;
  })

  document.getElementById("polls-ping").addEventListener("click", () => {
    channel
      .push("ping")
      .receive("ok", res => console.log("Received PING response:", res.message))
      .receive("error", res => console.log("Error sending PING:", res));
  })
}

export default socket;

using UnityEngine;

public class Move : MonoBehaviour
{
    public float Speed;

    private void Update()
    {
        transform.Translate(0, 0, Time.deltaTime * Speed, Space.Self);
    }
}